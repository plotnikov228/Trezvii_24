class SettingsState {
  final String language;
  final String locally;
  final bool emailNotificationDisabled;
  final bool pushNotificationDisabled;
  SettingsState({this.language = '', this.locally = '', this.emailNotificationDisabled = false, this.pushNotificationDisabled = false});
}