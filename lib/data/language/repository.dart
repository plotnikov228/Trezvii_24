import 'package:shared_preferences/shared_preferences.dart';
import 'package:sober_driver_analog/domain/language/models/language.dart';

import '../../domain/language/repository.dart';

class LanguageRepositoryImpl extends LanguageRepository {

  final _codeKey = 'lanCodeKey';

  final List<Language> languages = [
    Language(langCode: 'ru', name: 'Русский', countryCode: 'RU'),
    Language(langCode: 'en', name: 'English', countryCode: 'US')
  ];

  @override
  Future<Language> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_codeKey);
    if(code != null) {
      return languages.where((element) => element.langCode == code).first;
    } else {
      return languages.first;
    }
  }

  @override
  Future setLanguage(Language language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_codeKey, language.langCode);
  }

}