import 'package:sober_driver_analog/domain/language/models/language.dart';

abstract class LanguageRepository {
  Future<Language> getLanguage();
  Future setLanguage (Language language);
}