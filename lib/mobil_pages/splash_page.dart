import 'dart:async';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  startTimeout() {
    return Timer(const Duration(seconds: 2), changeScreen);
  }

  void changeScreen() {
    Navigator.of(context).pushReplacementNamed(
      '/homepage',
    );
  }

  @override
  void initState() {
    super.initState();
    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(28, 47, 67, 1),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/flutibre-logo.png',
              height: 400.0,
              width: 400.0,
            ),
          ],
        ),
      ),
    );
  }
}
