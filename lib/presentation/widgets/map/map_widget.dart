import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sober_driver_analog/data/map/repository/repository.dart';
import 'package:sober_driver_analog/domain/map/usecases/get_address_from_point.dart';
import 'package:sober_driver_analog/domain/map/usecases/get_last_point.dart';
import 'package:sober_driver_analog/domain/map/usecases/get_locally.dart';
import 'package:sober_driver_analog/domain/map/usecases/set_locally.dart';
import 'package:sober_driver_analog/extensions/point_extension.dart';
import 'package:sober_driver_analog/presentation/utils/app_images_util.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../domain/map/models/address_model.dart';
import '../../../domain/map/models/app_lat_long.dart';
import '../../../domain/map/usecases/check_permission.dart';
import '../../../domain/map/usecases/get_current_location.dart';
import '../../../domain/map/usecases/request_permission.dart';
import '../../../domain/map/usecases/set_last_point.dart';
import '../../utils/app_color_util.dart';

class MapWidget extends StatefulWidget {
  final Size size;
  final AppLatLong? firstPlacemark;
  final AppLatLong? secondPlacemark;
  final DrivingRoute? drivingRoute;
  final Function(AddressModel)? getAddress;
  final Function(CameraPosition)? getCameraPosition;
  final CameraPosition? initialCameraPosition;
  final Stream<DrivingRoute>? routeStream;
  final Completer<YandexMapController>? mapCompleter;
  final Widget? child;
  final bool follow;

  const MapWidget({
    super.key,
    this.getAddress,
    this.child,
    required this.size,
    this.getCameraPosition,
    this.initialCameraPosition,
    this.drivingRoute,
    this.firstPlacemark,
    this.secondPlacemark,
    this.follow = false,
    this.routeStream,
    this.mapCompleter,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPermission().ignore();
    mapControllerCompleter =
        widget.mapCompleter ?? Completer<YandexMapController>();
    _currentPoint = widget.initialCameraPosition?.target ??
        const KrasnodarLocation().toPoint();
  }

  final List<MapObject<dynamic>> _mapObjects = [];

  late final Completer<YandexMapController> mapControllerCompleter;
  final repo = MapRepositoryImpl();

  Future<void> _initPermission() async {
    if (!await CheckPermission(repo).call()) {
      await RequestPermission(repo).call();
    }
    if (widget.initialCameraPosition == null) {
      await _fetchCurrentLocation();
    }
  }

  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    const defLocation = KrasnodarLocation();
    try {
      location = await GetCurrentLocation(repo).call();
      SetLastPoint(repo).call(location);
    } catch (_) {
      location = defLocation;
    }
    _moveToCurrentLocation(location);
    try {
      final result = YandexSearch.searchByPoint(
          point: location.toPoint(), searchOptions: const SearchOptions());
      final address = (await result.result).items?.first;
      final locally = address?.toponymMetadata?.address
          .addressComponents[SearchComponentKind.locality];
      final savedLocally = await GetLocally(repo).call();
      if (locally != null && (savedLocally != locally)) {
        SetLocally(repo).call(locally);
      }
    } catch (_) {}
  }

  Future<void> _moveToCurrentLocation(
    AppLatLong appLatLong,
  ) async {
    _currentPoint = appLatLong.toPoint();
    final cameraPos = CameraPosition(
      target: _currentPoint!,
      zoom: zoom,
    );
    (await mapControllerCompleter.future).moveCamera(
      animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(cameraPos),
    );
    if (widget.getCameraPosition != null) {
      widget.getCameraPosition!(cameraPos);
    }
  }

  PolylineMapObject? _polylineMapObject;
  PlacemarkMapObject? _firstPlaceMark;
  PlacemarkMapObject? _secondPlaceMark;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mapControllerCompleter.future.then((value) => value.dispose());
    _listener?.cancel();
  }

  double zoom = 14;
  late Point _currentPoint;

  void getBounds(List<Point> points) {
    final lngs = points.map<double>((m) => m.longitude).toList();
    final lats = points.map<double>((m) => m.latitude).toList();

    final highestLat = lats.reduce(max);
    final highestLng = lngs.reduce(max);
    final lowestLat = lats.reduce(min);
    final lowestLng = lngs.reduce(min);

    mapControllerCompleter.future.then((value) => value.moveCamera(
        CameraUpdate.newBounds(
          BoundingBox(
            northEast: Point(latitude: highestLat, longitude: highestLng),
            southWest: Point(latitude: lowestLat, longitude: lowestLng),
          ),
        ),
        animation:
            const MapAnimation(type: MapAnimationType.linear, duration: 1)));
  }

  StreamSubscription<DrivingRoute>? _listener;
  DrivingRoute? _currentRoute;

  var lastChanges = DateTime.now();
  bool loading = false;

  Stream<DrivingRoute>? _stream;

  bool mapDrag = false;

  @override
  Widget build(BuildContext context) {
    if (_listener == null) {
      int mapObjectsCount = 0;
      if (widget.firstPlacemark != null &&
          (widget.firstPlacemark == _firstPlaceMark?.point.toAppLatLong()))
        mapObjectsCount++;
      if (widget.secondPlacemark != null &&
          (widget.firstPlacemark == _secondPlaceMark?.point.toAppLatLong()))
        mapObjectsCount++;
      if (widget.drivingRoute != null) mapObjectsCount++;
      if (_mapObjects.length != mapObjectsCount) {
        updateMapObjects();
      }
    }
    if (widget.routeStream == null) {
      _listener?.cancel();
      _listener = null;
    }
    if ((widget.routeStream != null && _listener == null) ||
        (widget.routeStream != null &&
            _stream != null &&
            _stream != widget.routeStream)) {
      _listener?.cancel();
      _listener = null;
      _stream = widget.routeStream;
      setListener();
    }

    return SizedBox(
      height: widget.size.height,
      width: widget.size.width,
      child: Stack(
        children: [
          Listener(
            onPointerDown: (_) => setState(() {
              mapDrag = true;
            }),
            onPointerUp: (_) => setState(() {
              mapDrag = false;
            }),
            child: YandexMap(
              onCameraPositionChanged: (_, __, ___) async {
                if (_.zoom != 2) {
                  zoom = _.zoom;
                }
                final p = _.target;
                setState(() {
                  _currentPoint = p;
                });
                lastChanges = DateTime.now();
                if (!loading) {
                  setState(() {
                    if (!widget.follow) {
                      loading = true;
                    }
                  });
                }

                Future.delayed(const Duration(seconds: 2), () async {
                  if (!widget.follow &&
                      (lastChanges.second - DateTime.now().second).abs() >= 2) {
                    final address = await GetAddressFromPoint(repo)
                        .call(AppLatLong(lat: p.latitude, long: p.longitude));
                    if (widget.getAddress != null && address != null) {
                      widget.getAddress!(address);
                    }
                    setState(() {
                      loading = false;
                    });
                  }
                });

                if (widget.getCameraPosition != null) {
                  widget.getCameraPosition!(_);
                }
              },
              onMapCreated: (controller) async {
                final lastPoint = await GetLastPoint(repo).call();
                final cameraPos = CameraPosition(
                  target: widget.initialCameraPosition?.target ??
                      lastPoint.toPoint(),
                  zoom: 13,
                );
                controller.moveCamera(
                  CameraUpdate.newCameraPosition(cameraPos),
                );
                if (widget.getCameraPosition != null) {
                  widget.getCameraPosition!(cameraPos);
                }
                mapControllerCompleter.complete(controller);
              },
              mapObjects: _mapObjects,
            ),
          ),
          if (_polylineMapObject == null)
            IgnorePointer(
              child: Center(
                child: Container(
                    width: widget.size.width - 90,
                    height: widget.size.width - 90,
                    decoration: BoxDecoration(
                        color: Colors.cyan.withOpacity(0.05),
                        shape: BoxShape.circle),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          AppImages.point,
                          width: 25,
                          height: 40,
                        ),
                        AnimatedOpacity(
                          opacity: loading ? 1 : 0,
                          duration: const Duration(seconds: 1),
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 5.9,
                                  color: AppColor.firstColor,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
              ),
            ),
          if (widget.child != null)
            AnimatedOpacity(
              opacity: mapDrag ? 0 : 1,
              duration: Duration(milliseconds: 200),
              child: widget.child!,
            )
        ],
      ),
    );
  }

  void setListener() {
    _mapObjects.removeRange(0, _mapObjects.length);
    print('init stream');

    _listener = widget.routeStream!.listen((event) async {
      if (event.geometry.isNotEmpty) {
        _currentPoint = event.geometry.first;

        _polylineMapObject = PolylineMapObject(
          mapId: const MapObjectId('0'),
          polyline: Polyline(
            points: event.geometry,
          ),
          strokeWidth: 3,
          strokeColor: AppColor.routeColor,
        );
        _mapObjects.add(_polylineMapObject!);
        _mapObjects.add(_firstPlaceMark = PlacemarkMapObject(
            opacity: 1,
            mapId: const MapObjectId('1'),
            point: event.geometry.first,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                  image:
                      BitmapDescriptor.fromAssetImage(AppImages.startPointPNG)),
            )));
        _mapObjects.add(_secondPlaceMark = PlacemarkMapObject(
            opacity: 1,
            mapId: const MapObjectId('2'),
            point: event.geometry.last,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                  image: BitmapDescriptor.fromAssetImage(AppImages.geoMarkPNG)),
            )));
        final cameraPos = CameraPosition(
          target: _currentPoint,
          zoom: zoom,
        );
        (await mapControllerCompleter.future).moveCamera(
          animation:
              const MapAnimation(type: MapAnimationType.linear, duration: 1),
          CameraUpdate.newCameraPosition(cameraPos),
        );
        setState(() {});
      }
    });
  }

  void updateMapObjects() {
    _mapObjects.removeRange(0, _mapObjects.length);
    if (_listener != null && widget.routeStream == null) {
      _listener?.cancel();
      _listener = null;
    }
    if (widget.drivingRoute != null) {
      if (_currentRoute != widget.drivingRoute) {
        getBounds([
          widget.drivingRoute!.geometry.first,
          widget.drivingRoute!.geometry.last
        ]);
        _currentRoute = widget.drivingRoute;
      }
      _polylineMapObject = PolylineMapObject(
        mapId: const MapObjectId('0'),
        polyline: Polyline(
          points: _currentRoute!.geometry,
        ),
        strokeWidth: 3,
        strokeColor: AppColor.routeColor,
      );
      _mapObjects.add(_polylineMapObject!);
    }
    if (widget.firstPlacemark != null) {
      _firstPlaceMark = PlacemarkMapObject(
        opacity: 1,
        mapId: const MapObjectId('1'),
        point: _currentRoute!.geometry.first,
        icon: PlacemarkIcon.composite([
          PlacemarkCompositeIconItem(
              name: 'user',
              style: PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage(
                  AppImages.startPointPNG,
                ),
                anchor: const Offset(0.5, 0.5),
              )),
        ]),
      );
      _mapObjects.add(_firstPlaceMark!);
    }
    if (widget.secondPlacemark != null) {
      _secondPlaceMark = PlacemarkMapObject(
        opacity: 1,
        mapId: const MapObjectId('2'),
        point: _currentRoute!.geometry.last,
        icon: PlacemarkIcon.single(PlacemarkIconStyle(
          anchor: const Offset(0.5, 0.8),
          image: BitmapDescriptor.fromAssetImage(AppImages.geoMarkPNG),
        )),
      );
      _mapObjects.add(_secondPlaceMark!);
    }
    setState(() {});
  }
}
