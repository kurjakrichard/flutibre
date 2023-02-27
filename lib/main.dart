import 'package:flutibre/model/booklist_item.dart';
import 'package:flutibre/providers/booklist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/l10n.dart';
import 'pages/homepage.dart';
import 'utils/custom_scroll_behavior.dart';
import 'widgets/theme.dart';
import 'dart:io' as io;

late SharedPreferences prefs;
final bookListProvider = ChangeNotifierProvider((ref) => BookListProvider());
final booklistProvider = FutureProvider<List<BookListItem>>(
    (ref) => BookListProvider().currentBooks!);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

//True if metadata.db exist and looks correct
  bool isMetadataDb = prefs.containsKey("path") &&
      io.File(prefs.getString('path')! + '/metadata.db').existsSync() &&
      io.File(prefs.getString('path')! + '/metadata.db') != 0;
  if (!isMetadataDb) {
    prefs.remove('path');
  }

  runApp(
    ProviderScope(child: Flutibre(isMetadataDb)),
  );
}

class Flutibre extends StatelessWidget {
  const Flutibre(this.isMetadataDb, {Key? key}) : super(key: key);

  final bool isMetadataDb;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: L10n.delegates,
      locale: Locale('hu'),
      supportedLocales: L10n.locales,
      theme: baseTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      scrollBehavior: CustomScrollBehavior(),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/homepage': (context) => const HomePage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutibre',
    );
  }
}
