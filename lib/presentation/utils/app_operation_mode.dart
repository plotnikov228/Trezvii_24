import 'package:shared_preferences/shared_preferences.dart';
import 'package:sober_driver_analog/presentation/app.dart';

enum AppOperationModeEnum { driver, user }

class AppOperationMode {
  static late AppOperationModeEnum _appOperationMode;

  static get mode => _appOperationMode;

  static Future setMode(AppOperationModeEnum _) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'appOperationMode', _ == AppOperationModeEnum.user ? 'user' : 'driver');
    _appOperationMode = _;
  }

  static Future initMode() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString('appOperationMode') ?? 'user';
    setMode(val == 'user'
        ? AppOperationModeEnum.user
        : AppOperationModeEnum.driver);
  }
}
