import 'package:flutibre/models/book_data.dart';
import 'package:flutibre/screens/modify_book.dart';
import 'package:flutibre/screens/book_details_page.dart';
import 'package:flutibre/screens/gridview.dart';
import 'package:flutibre/screens/datatable_view.dart';
import 'package:flutibre/screens/mainPage.dart';
import 'package:flutibre/utils/book_provider.dart';
import 'package:flutibre/utils/scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() => runApp(const Flutibre());

class Flutibre extends StatelessWidget {
  const Flutibre({Key? key}) : super(key: key);
  //final String path = readJsonData().toString();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookProvider>(
      create: (context) => BookProvider(),
      child: MaterialApp(
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
          //'/bookDetails': (context) => const BookDetailsPage(),
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
            //fejléc szövegek
            headline1: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
                fontSize: 18),
            //belső fejléc szövegek
            subtitle1: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize: 16),
            subtitle2: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize: 15),
            //gombszövegek
            headline3: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
                fontSize: 15),
            //nagyobb belső szövegek
            bodyText1: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize: 15),
            //kisebb belső szövegek
            bodyText2: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize: 12),
            //vastag belső szövegek
            headline2: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
          ),
        ),
      ),
    );
  }
}

class ResponsiveHomePage extends StatefulWidget {
  const ResponsiveHomePage({Key? key}) : super(key: key);

  @override
  State<ResponsiveHomePage> createState() => _ResponsiveHomePageState();
}

class _ResponsiveHomePageState extends State<ResponsiveHomePage> {
  BookData? book;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var isWideLayout = constraints.maxWidth > 600;
      if (!isWideLayout) {
        return MainPage(
          onBookTapped: (book) {
            Navigator.pushNamed(
              context,
              '/BookDetailsPage',
              arguments: book,
            );
          },
        );
      } else {
        return Row(
          children: [
            Expanded(child: MainPage(
              onBookTapped: (book) {
                setState(() {
                  this.book = book;
                });
              },
            )),
            const VerticalDivider(
              color: Colors.cyan,
              thickness: 3,
              width: 3,
            ),
            SizedBox(
                width: 300,
                child: BookDetailsContent(
                  book: book,
                )),
          ],
        );
      }
    });
  }
}
