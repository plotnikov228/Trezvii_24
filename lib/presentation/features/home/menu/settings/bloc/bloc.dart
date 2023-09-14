import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/domain/language/models/language.dart';
import 'package:sober_driver_analog/domain/language/usecases/get_language.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/settings/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/settings/bloc/state.dart';

import '../../../../../../data/language/repository.dart';
import '../../../../../../data/map/repository/repository.dart';
import '../../../../../../domain/map/usecases/get_locally.dart';

class SettingsBloc extends Bloc<SettingsEvent , SettingsState> {
  bool _emailVal = false;
  Language? _language;
  String _locally = '';

  final _mapRepo = MapRepositoryImpl();
  final _languageRepo = LanguageRepositoryImpl();

  SettingsBloc(super.initialState) {
    on<InitSettingsEvent>((event, emit) async  {
      _locally = await GetLocally(_mapRepo).call() ?? 'Москва';
      _language = await GetLanguage(_languageRepo).call();
    });
  }

}