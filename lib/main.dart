import 'package:flutibre/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    // theme: ThemeData(fontFamily: 'Raleway'),
    debugShowCheckedModeBanner: false,
    title: "Flutibre",
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Flutibre'),
      ),
      body: Home(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
        },
        child: const Icon(Icons.add),
        tooltip: 'Add one more item',
      ),
    ),
  ));
}
