import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: EasySplashScreen(
        logo: Image.asset('images/bookshelf-icon2.png'),
        title: const Text(
          "Futibre",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        showLoader: false,
        loadingText: const Text("Loading..."),
        navigator: "/homepage",
        durationInSeconds: 3,
      ),
    );
  }
}
