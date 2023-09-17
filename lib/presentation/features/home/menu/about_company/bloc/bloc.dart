import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/about_company/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/about_company/bloc/state.dart';

class AboutCompanyBloc extends Bloc<AboutCompanyEvent, AboutCompanyState>{
  AboutCompanyBloc(super.initialState) {
    on<InitAboutCompanyEvent>((event, emit) async {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.fetch();
      await remoteConfig.activate();
      final description = remoteConfig.getString('company_description');
      emit(AboutCompanyState(description: description));
    });
  }

}

