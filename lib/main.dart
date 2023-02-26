import 'package:flutibre_pro/pages/book_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutibre_pro/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/l10n.dart';
import 'pages/homepage.dart';
import 'pages/settingspage.dart';
import 'providers/booklist_provider.dart';
import 'providers/locale_provider.dart';
import 'utils/custom_scroll_behavior.dart';
import 'widgets/theme.dart';
import 'dart:io' as io;

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  prefs = await SharedPreferences.getInstance();

//True if metadata.db exist and looks correct
  bool isMetadataDb = prefs.containsKey("path") &&
      io.File(prefs.getString('path')! + '/metadata.db').existsSync() &&
      io.File(prefs.getString('path')! + '/metadata.db') != 0;
  if (!isMetadataDb) {
    prefs.remove('path');
  }

  runApp(
    FlutibrePro(isMetadataDb),
  );
}

class FlutibrePro extends StatelessWidget {
  const FlutibrePro(this.isMetadataDb, {Key? key}) : super(key: key);

  final bool isMetadataDb;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
        ChangeNotifierProvider(create: (context) => BookListProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, locale, child) => Consumer<ThemeProvider>(
            builder: ((context, value, child) => MaterialApp(
                  localizationsDelegates: L10n.delegates,
                  locale: locale.currentLocale,
                  supportedLocales: L10n.locales,
                  theme: baseTheme,
                  darkTheme: darkTheme,
                  themeMode: value.darkTheme ? ThemeMode.dark : ThemeMode.light,
                  scrollBehavior: CustomScrollBehavior(),
                  initialRoute: '/',
                  routes: {
                    '/': (context) =>
                        isMetadataDb ? const HomePage() : const SettingsPage(),
                    '/homepage': (context) => const HomePage(),
                    '/bookdetailspage': (context) => const BookDetailsPage(),
                    '/settings': (context) => const SettingsPage(),
                  },
                  debugShowCheckedModeBanner: false,
                  title: 'Flutibre',
                ))),
      ),
    );
  }
}
