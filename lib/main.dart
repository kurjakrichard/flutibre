import 'package:flutibre/screens/book_details_page.dart';
import 'package:flutibre/screens/gridview.dart';
import 'package:flutibre/screens/listview.dart';
import 'package:flutibre/screens/main_window.dart';
import 'package:flutibre/utils/book_repository.dart';
import 'package:flutibre/utils/scroll.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      home: Flutibre(),
      debugShowCheckedModeBanner: false,
    ));

class Flutibre extends StatelessWidget {
  const Flutibre({Key? key}) : super(key: key);
  //final String path = readJsonData().toString();

  @override
  Widget build(BuildContext context) {
    return BookRepositoryProvider(
      child: Builder(builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          scrollBehavior: MyCustomScrollBehavior(),
          home: const MainWindow(),
          routes: {
            //'/bookDetails': (context) => const BookDetailsPage(),
            '/listPage': (context) => ListPage(),
            '/gridPage': (context) => GridPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name?.startsWith('/book/') ?? false) {
              var id = int.parse(settings.name!.split('/')[2]);
              var repository = BookRepository.of(context);
              var bookList = repository.books;
              var book = bookList.firstWhere((element) => element.id == id);
              return MaterialPageRoute(
                  builder: (context) => const BookDetailsPage(),
                  settings: settings.copyWith(arguments: book));
            }
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
            textTheme: const TextTheme(
              //fejléc szövegek
              headline1: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontSize: 18),
              //belső fejléc szövegek
              subtitle1: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontSize: 16),
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
              headline2: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15),
            ),
          ),
        );
      }),
    );
  }
}
