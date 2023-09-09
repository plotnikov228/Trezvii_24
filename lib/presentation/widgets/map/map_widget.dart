import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sober_driver_analog/data/map/repository/repository.dart';
import 'package:sober_driver_analog/domain/map/usecases/get_address_from_point.dart';
import 'package:sober_driver_analog/domain/map/usecases/get_last_point.dart';
import 'package:sober_driver_analog/extensions/point_extension.dart';
import 'package:sober_driver_analog/presentation/utils/app_images_util.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../domain/map/models/address_model.dart';
import '../../../domain/map/models/app_lat_long.dart';
import '../../../domain/map/usecases/check_permission.dart';
import '../../../domain/map/usecases/get_current_location.dart';
import '../../../domain/map/usecases/get_routes.dart';
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

  final bool follow;

  const MapWidget({super.key,
    this.getAddress,
    required this.size,
    this.getCameraPosition,
    this.initialCameraPosition,
    this.drivingRoute,
    this.firstPlacemark,
    this.secondPlacemark, this.follow = false});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPermission().ignore();
    _currentPoint = widget.initialCameraPosition?.target ??
        const MoscowLocation().toPoint();
  }

  final List<MapObject<dynamic>> _mapObjects = [];

  final mapControllerCompleter = Completer<YandexMapController>();
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
    const defLocation = MoscowLocation();
    try {
      location = await GetCurrentLocation(repo).call();
      SetLastPoint(repo).call(location);
    } catch (_) {
      location = defLocation;
    }
    _moveToCurrentLocation(location);
  }

  Future<void> _moveToCurrentLocation(AppLatLong appLatLong,) async {
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mapControllerCompleter.future.then((value) => value.dispose());
    if (_listener != null) _listener!.cancel();
  }

  double zoom = 14;
  late Point _currentPoint;

  BoundingBox getBounds(List<Point> points) {
    final lngs = points.map<double>((m) => m.longitude).toList();
    final lats = points.map<double>((m) => m.latitude).toList();

    final highestLat = lats.reduce(max);
    final highestLng = lngs.reduce(max);
    final lowestLat = lats.reduce(min);
    final lowestLng = lngs.reduce(min);

    return BoundingBox(
      northEast: Point(latitude: highestLat, longitude: highestLng),
      southWest: Point(latitude: lowestLat, longitude: lowestLng),
    );
  }

  StreamSubscription<Position>? _listener;
  DrivingRoute? _currentRoute;

  var lastChanges = DateTime.now();

  @override
  Widget build(BuildContext context) {
    _mapObjects.removeRange(0, _mapObjects.length);
    if (_listener != null && !widget.follow) {
      _listener?.cancel();
      _listener = null;
    }
    if (_listener == null && widget.follow) {
      _listener = Geolocator.getPositionStream().listen((event) async {
        _currentPoint =
            Point(latitude: event.latitude, longitude: event.longitude);

        _currentRoute = (await GetRoutes(repo)
            .call([_currentPoint.toAppLatLong(), widget.secondPlacemark!]))!
            .first;
        _polylineMapObject = PolylineMapObject(
          mapId: const MapObjectId('0'),
          polyline: Polyline(
            points: _currentRoute!.geometry,
          ),
          strokeWidth: 3,
          strokeColor: AppColor.routeColor,
        );
        final cameraPos = CameraPosition(
          target: _currentPoint,
          zoom: zoom,
        );
        (await mapControllerCompleter.future).moveCamera(
          animation: const MapAnimation(
              type: MapAnimationType.linear, duration: 0),
          CameraUpdate.newCameraPosition(cameraPos),
        );
        setState(() {});
      });
    }
    if ( widget.drivingRoute != null && !widget.follow) {
       _currentRoute = widget.drivingRoute;
       _polylineMapObject =PolylineMapObject(
         mapId: const MapObjectId('0'),
         polyline: Polyline(
           points: _currentRoute!.geometry,
         ),
         strokeWidth: 3,
         strokeColor: AppColor.routeColor,
       );
          _mapObjects.add(_polylineMapObject!);
          setState(() {

          });
    }
    if (widget.firstPlacemark != null && !widget.follow) {

      _mapObjects.add(PlacemarkMapObject(
        opacity: 1,
          mapId: const MapObjectId('1'),
          point: widget.firstPlacemark!.toPoint(),
          icon: PlacemarkIcon.single(
                PlacemarkIconStyle(
                    image: BitmapDescriptor.fromAssetImage(
                        AppImages.startPointPNG)),

          )));
    }
    if (widget.secondPlacemark != null) {
      _mapObjects.add(PlacemarkMapObject(
        opacity: 1,
          mapId: const MapObjectId('2'),
          point: widget.secondPlacemark!.toPoint(),
          icon:PlacemarkIcon.single(
                 PlacemarkIconStyle(
                    image:
                    BitmapDescriptor.fromAssetImage(AppImages.geoMarkPNG)),
                )
          ));
    }
    return SizedBox(
      height: widget.size.height,
      width: widget.size.width,
      child: Stack(
        children: [
          YandexMap(
            onCameraPositionChanged: (_, __, ___) async {
              zoom = _.zoom;
              final p = _.target;
              setState(() {
                _currentPoint = p;
              });
              lastChanges = DateTime.now();
              Future.delayed(Duration(seconds: 2), () async {
                if (!widget.follow && (lastChanges.second - DateTime.now().second).abs() >= 2) {
                  final address = await GetAddressFromPoint(repo)
                      .call(AppLatLong(lat: p.latitude, long: p.longitude));
                  if (widget.getAddress != null && address != null) {
                    widget.getAddress!(address);
                  }
                }
              });


              if (widget.getCameraPosition != null) {
                widget.getCameraPosition!(_);
              }
            },
            onMapCreated: (controller) async {
              final lastPoint = await GetLastPoint(repo).call();
              final cameraPos = CameraPosition(
                target:
                widget.initialCameraPosition?.target ?? lastPoint.toPoint(),
                zoom: widget.initialCameraPosition?.zoom ?? zoom,
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
          if (_polylineMapObject == null)
            IgnorePointer(
              child: Center(
                child: Container(
                    width: widget.size.width - 90,
                    height: widget.size.width - 90,
                    decoration: BoxDecoration(
                        color: Colors.cyan.withOpacity(0.05),
                        shape: BoxShape.circle),
                    child: Image.asset(AppImages.point)),
              ),
            )
        ],
      ),
    );
  }
}
