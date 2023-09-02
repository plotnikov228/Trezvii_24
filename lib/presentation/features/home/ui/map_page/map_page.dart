import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/ui/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/ui/map_page/bloc/state/state.dart';
import 'package:sober_driver_analog/presentation/features/home/ui/map_page/widgets/pages/create_order_widget.dart';
import 'package:sober_driver_analog/presentation/features/home/ui/map_page/widgets/pages/initial_map_widget.dart';
import 'package:sober_driver_analog/presentation/features/home/ui/map_page/widgets/pages/select_address_widget.dart';
import 'package:sober_driver_analog/presentation/widgets/map/map_widget.dart';

import '../../../../utils/app_color_util.dart';
import '../../../../utils/size_util.dart';
import '../../../../utils/status_enum.dart';
import '../../../../widgets/app_snack_bar.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapState>( listener: (prev, cur) {
      if (cur.exception != null && cur.message != null) {
        AppSnackBar.showSnackBar(context, content: cur.exception ?? cur.message!);
      }
      else if (cur.status == Status.Loading) {
        showDialog(
            barrierColor: Colors.transparent,
            context: context, builder: (context) {
          return Center(
            child: Container(
              width: 150,
              height: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: const BorderRadius.all(Radius.circular(8))
              ),
              child: Center(child: CircularProgressIndicator(
                color: AppColor.firstColor,
              ),),
            ),
          );
        });
      }
    },
        listenWhen: (prev, cur) => cur.message != null || cur.status != Status.Success,
        builder: (context, state) {
      final bloc = context.read<MapBloc>();
      return Stack(
        children: [
          MapWidget(size: Size(size.width, size.height - 160),
          getCameraPosition: (_) {
            bloc.setCameraPosition(_);
          },
            firstPlacemark: bloc.firstPoint,
            secondPlacemark: bloc.secondPoint,
            polylineMapObject: bloc.polylineMapObject,
            getAddress: (_) {
              if(bloc.getAddressFromMap) {
                bloc.fromAddress = _;
                bloc.firstAddressController.text = _.addressName;
              }
            },
            initialCameraPosition: bloc.cameraPosition,
          ),
          if(state is InitialMapState)
            Align(
                alignment: Alignment.bottomCenter,
                child: InitialMapWidget(state: state, bloc: bloc,)),
          if(state is SelectAddressesMapState)
            Align(
                alignment: Alignment.bottomCenter,
                child: SelectAddressWidget(bloc: bloc, state: state)),
          if(state is CreateOrderMapState)
            Align(
              alignment: Alignment.bottomCenter,
              child: CreateOrderWidget(bloc: bloc, state: state,),
            )


        ],
      );
    });
  }
}
