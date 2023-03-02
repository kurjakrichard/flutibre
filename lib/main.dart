import 'package:flutibre/model/booklist_item.dart';
import 'package:flutibre/providers/booklist_provider.dart';
import 'package:flutibre/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/l10n.dart';
import 'pages/homepage.dart';
import 'pages/loadingpage.dart';
import 'pages/settingspage.dart';
import 'providers/locale_provider.dart';
import 'utils/custom_scroll_behavior.dart';
import 'widgets/theme.dart';
import 'dart:io' as io;

late SharedPreferences prefs;
final bookListProvider = ChangeNotifierProvider((ref) => BookListProvider());
final themeProvider = ChangeNotifierProvider((ref) => ThemeProvider());
final localeProvider = ChangeNotifierProvider((ref) => LocaleProvider());
final booklistProvider = FutureProvider<List<BookListItem>>(
    (ref) => BookListProvider().currentBooks!);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();
  int? bytes;

  try {
    bytes = await io.File('${prefs.getString('path')}/metadata.db').length();
  } on Exception {
    bytes = 0;
  }

//True if metadata.db exist and looks correct
  bool isMetadataDb = prefs.containsKey("path") && bytes != 0;
  if (!isMetadataDb) {
    prefs.remove('path');
  }

  runApp(ProviderScope(
    child: Flutibre(isMetadataDb),
  ));
}

class Flutibre extends StatelessWidget {
  const Flutibre(this.isMetadataDb, {Key? key}) : super(key: key);

  final bool isMetadataDb;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => ref.watch(themeProvider).doneLoading
          ? MaterialApp(
              localizationsDelegates: L10n.delegates,
              locale: ref.watch(localeProvider).currentLocale,
              supportedLocales: L10n.locales,
              theme: baseTheme,
              darkTheme: darkTheme,
              themeMode: ref.watch(themeProvider).darkTheme
                  ? ThemeMode.dark
                  : ThemeMode.light,
              scrollBehavior: CustomScrollBehavior(),
              initialRoute: '/',
              routes: {
                '/': (context) =>
                    isMetadataDb ? const HomePage() : const SettingsPage(),
                '/homepage': (context) => const HomePage(),
                '/settings': (context) => const SettingsPage(),
              },
              debugShowCheckedModeBanner: false,
              title: 'Flutibre',
            )
          : const LoadingPage(),
    );
  }
}
