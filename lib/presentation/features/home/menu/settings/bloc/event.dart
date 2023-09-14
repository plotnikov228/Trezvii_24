abstract class SettingsEvent {}

class InitSettingsEvent extends SettingsEvent {}

class ChangeLocallySettingsEvent extends SettingsEvent {
  final String locally;

  ChangeLocallySettingsEvent({required this.locally});
}

class ChangeLanguageSettingsEvent extends SettingsEvent {

}

class ChangeEmailDisabledSettingsEvent extends SettingsEvent {
  final bool val;

  ChangeEmailDisabledSettingsEvent({required this.val});
}