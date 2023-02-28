import 'package:flutter/material.dart';
import '../main.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider() {
    _loadSettings();
  }

  bool _darkTheme = false;

  // ignore: unnecessary_getters_setters
  bool get darkTheme => _darkTheme;

  void _loadSettings() async {
    _darkTheme = prefs.getBool('darkTheme') ?? false;
    notifyListeners();
  }

  void _saveSettings() async {
    prefs.setBool('darkTheme', _darkTheme);
  }

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveSettings();
    notifyListeners();
  }
}
