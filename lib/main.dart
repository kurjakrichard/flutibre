import 'package:flutibre/screens/main_window.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      home: const MainWindow(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.cyan,
          foregroundColor: Colors.white,
        ),
        fontFamily: 'NotoSans',
        textTheme: const TextTheme(
          //fejléc szövegek
          headline1: TextStyle(
              fontWeight: FontWeight.normal, color: Colors.white, fontSize: 16),
          //belső fejléc szövegek
          subtitle1: TextStyle(
              fontWeight: FontWeight.normal, color: Colors.white, fontSize: 14),
          //nagyobb belső szövegek
          bodyText1: TextStyle(
              fontWeight: FontWeight.normal, color: Colors.black, fontSize: 12),
          //kisebb belső szövegek
          bodyText2: TextStyle(
              fontWeight: FontWeight.normal, color: Colors.black, fontSize: 11),
        ),
      ),
    );
  }
}
