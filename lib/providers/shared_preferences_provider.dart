import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/utils.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final sharedUtilityProvider = Provider<SharedUtility>((ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return SharedUtility(sharedPreferences: sharedPrefs);
});

class SharedUtility {
  SharedUtility({
    required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;

  bool isDarkTheme() {
    return sharedPreferences.getBool(sharedDarkModeKey) ?? false;
  }

  void setDarkMode({required bool isdark}) {
    sharedPreferences.setBool(sharedDarkModeKey, isdark);
  }

  String getLocaleKey() {
    return sharedPreferences.getString(shareLocaleKey) ?? 'en';
  }

  void setLocale({required String locale}) {
    sharedPreferences.setString(shareLocaleKey, locale);
  }

  String getPath() {
    return sharedPreferences.getString(shareLocaleKey) ?? '';
  }

  void setPath({required String path}) {
    sharedPreferences.setString(shareLocaleKey, path);
  }

  String getMode() {
    return sharedPreferences.getString(shareModeKey) ?? '';
  }

  void setMode({required String mode}) {
    sharedPreferences.setString(shareModeKey, mode);
  }
}
