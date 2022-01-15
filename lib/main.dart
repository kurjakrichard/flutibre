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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: MyCustomScrollBehavior(),
        home: MainWindow(),
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
          ),
        ),
      ),
    );
  }
}
