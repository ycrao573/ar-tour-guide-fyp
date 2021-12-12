import 'package:flutter/material.dart';
import 'l10n/l10n.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = Locale('en', 'US');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = Locale('en', 'US');
    notifyListeners();
  }
}