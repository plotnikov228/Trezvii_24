import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/domain/firebase/notification/usecases/add_user_to_newsletter.dart';
import 'package:sober_driver_analog/domain/firebase/notification/usecases/add_user_to_pushes.dart';
import 'package:sober_driver_analog/domain/firebase/notification/usecases/delete_user_from_newsletter.dart';
import 'package:sober_driver_analog/domain/firebase/notification/usecases/delete_user_from_pushes.dart';
import 'package:sober_driver_analog/domain/firebase/notification/usecases/user_subscribe_to_newsletter.dart';
import 'package:sober_driver_analog/domain/firebase/notification/usecases/user_subscribe_to_pushes.dart';
import 'package:sober_driver_analog/domain/language/models/language.dart';
import 'package:sober_driver_analog/domain/language/usecases/get_language.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/settings/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/settings/bloc/state.dart';

import '../../../../../../data/firebase/notification/repository.dart';
import '../../../../../../data/language/repository.dart';
import '../../../../../../data/map/repository/repository.dart';
import '../../../../../../domain/map/usecases/get_locally.dart';

class SettingsBloc extends Bloc<SettingsEvent , SettingsState> {
  bool _emailVal = false;
  bool _pushVal = false;
  Language? _language;
  String _locally = '';

  final _mapRepo = MapRepositoryImpl();
  final _languageRepo = LanguageRepositoryImpl();
  final _notificationRepo = NotificationRepositoryImpl();

  SettingsBloc(super.initialState) {
    on<InitSettingsEvent>((event, emit) async  {
      _locally = await GetLocally(_mapRepo).call() ?? 'Краснодар';
      _language = await GetLanguage(_languageRepo).call();
      _emailVal = !(await UserSubscribeToNewsletter(_notificationRepo).call());
      _pushVal = !(await UserSubscribeToPushes(_notificationRepo).call());
      emit(SettingsState(language: _language?.name ?? _languageRepo.languages.first.name, locally: _locally, pushNotificationDisabled: _pushVal, emailNotificationDisabled: _emailVal));
    });

    on<ChangeNotifyDisabledSettingsEvent>((event, emit) async {
      try {
        if (event.email != _emailVal) {
          if (event.email) {
            await DeleteUserFromNewsletter(_notificationRepo).call();
          } else {
            await AddUserToNewsletter(_notificationRepo).call();
          }
        }
        if (event.push != _pushVal) {
          if (event.email) {
            await DeleteUserFromPushes(_notificationRepo).call();
          } else {
            await AddUserToPushes(_notificationRepo).call();
          }
        }
      } catch (_) {

      }
      _emailVal = event.email;
      _pushVal = event.push;

      emit(SettingsState(language: _language?.name ?? _languageRepo.languages.first.name, locally: _locally, pushNotificationDisabled: _pushVal, emailNotificationDisabled: _emailVal));
    });
  }

}