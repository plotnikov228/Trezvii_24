abstract class SettingsEvent {}

class InitSettingsEvent extends SettingsEvent {}

class ChangeLocallySettingsEvent extends SettingsEvent {
  final String locally;

  ChangeLocallySettingsEvent({required this.locally});
}

class ChangeLanguageSettingsEvent extends SettingsEvent {

}

class ChangeNotifyDisabledSettingsEvent extends SettingsEvent {
  final bool email;
  final bool push;


  ChangeNotifyDisabledSettingsEvent( {required this.push,required this.email});
}