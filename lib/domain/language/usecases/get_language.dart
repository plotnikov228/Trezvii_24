import 'package:sober_driver_analog/domain/language/repository.dart';

import '../models/language.dart';

class GetLanguage {
  final LanguageRepository repository;

  GetLanguage(this.repository);

  Future<Language> call () {
    return repository.getLanguage();
  }
}