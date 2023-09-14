import 'package:sober_driver_analog/domain/language/repository.dart';

import '../models/language.dart';

class SetLanguage {
  final LanguageRepository repository;

  SetLanguage(this.repository);

  Future call (Language language) {
    return repository.setLanguage(language);
  }
}