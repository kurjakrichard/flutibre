import 'package:flutibre_pro/l10n/l10n.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class LocaleProvider with ChangeNotifier {
  LocaleProvider() {
    _loadSettings();
  }

  Locale _currentLocale = const Locale('en');

  // ignore: unnecessary_getters_setters
  Locale get currentLocale => _currentLocale;

  void _loadSettings() async {
    _currentLocale = Locale(prefs.getString('locale') ?? 'hu');
    notifyListeners();
  }

  void _saveSettings(String newValue) async {
    prefs.setString('locale', newValue);
  }

  void setLocale(Locale newValue) {
    if (!L10n.locales.contains(newValue)) return;
    _saveSettings(newValue.languageCode);
    _currentLocale = newValue;
    notifyListeners();
  }
}
