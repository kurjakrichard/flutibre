import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart';

class LoadingPage extends ConsumerStatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoadingPage> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingPage> {
  final Duration initialDelay = const Duration(seconds: 0);
  @override
  initState() {
    wait();
    super.initState();
  }

  void wait() async {
    await Future.delayed(const Duration(seconds: 3));

    ref.read(loadProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Flutibre',
              style: TextStyle(fontSize: 28),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: SizedBox(
                  height: 175,
                  child: Image.asset(
                    'images/bookshelf-icon2.png',
                    fit: BoxFit.fitWidth,
                  )),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  delayedDisplay(100, 'Loading'),
                  delayedDisplay(500, '.'),
                  delayedDisplay(1000, '.'),
                  delayedDisplay(1500, '.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget delayedDisplay(int delay, String displayText) {
    return DelayedDisplay(
      delay: Duration(milliseconds: initialDelay.inSeconds + delay),
      child: Text(
        displayText,
        style: const TextStyle(
          fontSize: 26.0,
        ),
      ),
    );
  }
}
