import 'package:flutibre/screens/modify_book.dart';
import 'package:flutibre/screens/book_details_page.dart';
import 'package:flutibre/screens/gridview.dart';
import 'package:flutibre/screens/datatable_view.dart';
import 'package:flutibre/screens/responsive_homepage.dart';
import 'package:flutibre/utils/book_provider.dart';
import 'package:flutibre/utils/scroll.dart';
import 'package:flutibre/utils/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const Flutibre(),
    ),
  );
}

class Flutibre extends StatelessWidget {
  const Flutibre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('hu', ''),
      ],

      locale: const Locale('hu'),
      debugShowCheckedModeBanner: false,
      //Scrolling do not work on Linux desktop without this.
      scrollBehavior: MyCustomScrollBehavior(),
      home: const ResponsiveHomePage(),
      routes: {
        '/ListPage': (context) => const ListPage(),
        '/GridPage': (context) => const GridPage(),
        '/AddBookPage': (context) =>
            ModifyBookPage(title: AppLocalizations.of(context)!.addbook),
        '/BookDetailsPage': (context) => const BookDetailsPage(),
      },

      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.cyan,
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.cyan[50],
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.cyan, foregroundColor: Colors.white),
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            primary: Colors.cyan,
          ),
        ),
        textTheme: const TextTheme(
          //fejl??c sz??vegek
          headline1: TextStyle(
              fontWeight: FontWeight.normal, color: Colors.white, fontSize: 18),
          //bels?? fejl??c sz??vegek
          subtitle1: TextStyle(
              fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
          subtitle2: TextStyle(
              fontWeight: FontWeight.normal, color: Colors.black, fontSize: 15),
          //gombsz??vegek
          headline3: TextStyle(
              fontWeight: FontWeight.normal, color: Colors.white, fontSize: 15),
          //nagyobb bels?? sz??vegek
          bodyText1: TextStyle(
              fontWeight: FontWeight.normal, color: Colors.black, fontSize: 15),
          //kisebb bels?? sz??vegek
          bodyText2: TextStyle(
              fontWeight: FontWeight.normal, color: Colors.black, fontSize: 12),
          //vastag bels?? sz??vegek
          headline2: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
        ),
      ),
    );
  }
}
