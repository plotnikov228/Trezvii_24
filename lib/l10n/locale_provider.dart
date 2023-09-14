import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'all_locales.dart';
class LocaleProvider with ChangeNotifier {
  Locale? _locale;
  Locale get locale => _locale ?? AllLocale.all.first;
  void setLocale(Locale locale) {
    if (!AllLocale.all.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }

  static LocaleProvider provider(BuildContext context) => Provider.of<LocaleProvider>(context,listen: false);
}