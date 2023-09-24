import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../utils/app_color_util.dart';
import '../../utils/app_operation_mode.dart';

class MapByStream extends StatelessWidget {
  final Stream<DrivingRoute> route;
  final Size size;
  final Function(CameraPosition)? getCameraPosition;
  final double zoom;
   MapByStream({Key? key, required this.route, required this.size, this.getCameraPosition, required this.zoom}) : super(key: key);

  final mapControllerCompleter = Completer<YandexMapController>();

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: size.height,
      width: size.width,
      child: StreamBuilder(
       stream: route,
        builder:(context, snapshot) {
         if(snapshot.connectionState == ConnectionState.waiting) return Container();

          return YandexMap(
            onCameraPositionChanged: (_, __, ___) async {
              if (getCameraPosition != null) {
                getCameraPosition!(_);
              }
            },
            onMapCreated: (controller) async {
              final cameraPos = CameraPosition(
                target: snapshot.data!.geometry.first
                ,
                zoom: zoom,
              );
              controller.moveCamera(
                CameraUpdate.newCameraPosition(cameraPos),
              );
              if (getCameraPosition != null) {
                getCameraPosition!(cameraPos);
              }
              mapControllerCompleter.complete(controller);
            },
            mapObjects: [MapObjectCollection(mapId: const MapObjectId('4'), mapObjects: [
              PolylineMapObject(
                mapId: const MapObjectId('5'),
                polyline: Polyline(
                  points: snapshot.data!.geometry,
                ),
                strokeWidth: 3,
                strokeColor: AppColor.routeColor,
              ),
              //PlacemarkMapObject(mapId: const MapObjectId('6'), point: snapshot.data!.geometry.first, icon: PlacemarkIcon.single(PlacemarkIconStyle(image: BitmapDescriptor)))
            ])],
          );
        }
      ),
    );
  }
}
