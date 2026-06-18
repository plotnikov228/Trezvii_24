import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/app.dart';
import 'presentation/utils/app_color_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(milliseconds: 1000));
  await Firebase.initializeApp();
  AppColor.initColors();
  runApp(const App());
}
