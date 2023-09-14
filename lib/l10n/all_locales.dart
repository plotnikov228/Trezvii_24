import 'package:flutter/material.dart';
import 'package:sober_driver_analog/data/language/repository.dart';
import 'package:sober_driver_analog/domain/language/models/language.dart';

class AllLocale {

  static final all = LanguageRepositoryImpl().languages.map((e) => Locale(e.langCode, e.countryCode));
}