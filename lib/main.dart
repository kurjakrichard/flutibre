import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app.dart';
import 'providers/providers.dart';

late SharedPreferences prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      observers: [
        MyObserver(),
      ],
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const Flutibre(),
    ),
  );
}
