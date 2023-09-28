import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('images/bookshelf-icon2.png'),
      title: const Text(
        "Flutibre",
        style: TextStyle(
          color: Colors.black,
          fontSize: 28,
          fontWeight: FontWeight.normal,
        ),
      ),
      //backgroundColor: Colors.cyan.shade50,
      showLoader: true,
      loaderColor: Colors.black,
      loadingText: Text(
        "${AppLocalizations.of(context)!.loading}...",
        style: const TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.normal,
        ),
      ),
      navigator: const HomePage(),
      durationInSeconds: 3,
    );
  }
}
