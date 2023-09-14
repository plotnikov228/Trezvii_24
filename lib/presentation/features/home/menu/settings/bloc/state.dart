class SettingsState {
  final String language;
  final String locally;
  final bool emailNotificationDisabled;

  SettingsState({this.language = '', this.locally = '', this.emailNotificationDisabled = false});
}