import 'package:flutibre/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/l10n.dart';
import 'pages/add_edit_page.dart';
import 'pages/book_details_page.dart';
import 'pages/homepage.dart';
import 'pages/loadingpage.dart';
import 'pages/settingspage.dart';
import 'providers/locale_provider.dart';
import 'providers/shared_preferences_provider.dart';
import 'utils/custom_scroll_behavior.dart';
import 'widgets/theme.dart';
import 'dart:io' as io;

late SharedPreferences prefs;
final loadProvider = StateProvider<bool>((ref) {
  return false;
});
final themeProvider = StateNotifierProvider<ThemeProvider, bool>((ref) {
  return ThemeProvider(ref: ref);
});
final localeProvider = StateNotifierProvider<LocaleProvider, String>((ref) {
  return LocaleProvider(ref: ref);
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();
  bool isMetadataDb = false;

  try {
    await io.File('${prefs.getString('path')}/metadata.db').length();
    isMetadataDb = true;
  } on Exception {
    prefs.remove('path');
  }

  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: Flutibre(isMetadataDb),
  ));
}

class Flutibre extends StatelessWidget {
  const Flutibre(this.isMetadataDb, {Key? key}) : super(key: key);

  final bool isMetadataDb;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => ref.watch(loadProvider)
          ? MaterialApp(
              localizationsDelegates: L10n.delegates,
              locale: Locale(ref.watch(localeProvider)),
              supportedLocales: L10n.locales,
              theme: baseTheme,
              darkTheme: darkTheme,
              themeMode:
                  ref.watch(themeProvider) ? ThemeMode.dark : ThemeMode.light,
              scrollBehavior: CustomScrollBehavior(),
              initialRoute: '/',
              routes: {
                '/': (context) =>
                    isMetadataDb ? const HomePage() : const SettingsPage(),
                '/homepage': (context) => const HomePage(),
                '/bookdetailspage': (context) => BookDetailsPage(),
                '/settings': (context) => const SettingsPage(),
                '/addpage': (context) => const AddEditPage(
                      title: 'Add book',
                    ),
                '/editpage': (context) => const AddEditPage(
                      title: 'Edit book',
                    )
              },
              debugShowCheckedModeBanner: false,
              title: 'Flutibre',
            )
          : const LoadingPage(),
    );
  }
}
