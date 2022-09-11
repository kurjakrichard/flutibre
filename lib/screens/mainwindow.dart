import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(children: [Text('Greeting page')]),
      ),
      appBar: AppBar(
        title: Text('Flutibre'),
      ),
    );
  }
}
