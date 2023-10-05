import 'package:flutibre/pages/splash_page.dart';
import 'package:flutibre/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'l10n/l10n.dart';
import 'pages/update_page.dart';
import 'pages/book_details_page.dart';
import 'pages/homepage.dart';
import 'pages/settingspage.dart';
import 'providers/locale_provider.dart';
import 'providers/path_provider.dart';
import 'providers/shared_preferences_provider.dart';
import 'utils/custom_scroll_behavior.dart';
import 'widgets/theme.dart';
import 'dart:io' as io;

late SharedPreferences prefs;
final themeProvider = StateNotifierProvider<ThemeProvider, bool>((ref) {
  return ThemeProvider(ref: ref);
});
final localeProvider = StateNotifierProvider<LocaleProvider, String>((ref) {
  return LocaleProvider(ref: ref);
});
final pathProvider = StateNotifierProvider<PathProvider, String>((ref) {
  return PathProvider(ref: ref);
});
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();

  try {
    await io.File('${prefs.getString('path')}/metadata.db').length();
  } on Exception {
    prefs.remove('path');
  }

  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: const Flutibre(),
  ));
}

class Flutibre extends StatelessWidget {
  const Flutibre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, ref, child) => MaterialApp(
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
                '/': (context) => ref.watch(pathProvider).isNotEmpty
                    ? const SplashPage()
                    : const SettingsPage(),
                '/homepage': (context) => const HomePage(),
                '/bookdetailspage': (context) => const BookDetailsPage(),
                '/settings': (context) => const SettingsPage(),
                '/addpage': (context) => UpdatePage(
                      title: AppLocalizations.of(context)!.addbook,
                    ),
                '/editpage': (context) => UpdatePage(
                      title: AppLocalizations.of(context)!.editbook,
                    )
              },
              debugShowCheckedModeBanner: false,
              title: 'Flutibre',
            ));
  }
}
