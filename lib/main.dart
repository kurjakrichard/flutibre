import 'dart:convert';
import 'dart:io';
import 'package:flutibre/screens/main_window.dart';
import 'package:flutibre/utils/scroll.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: Flutibre(),
      debugShowCheckedModeBanner: false,
    ));

class Flutibre extends StatelessWidget {
  Flutibre({Key? key}) : super(key: key);
  final String path = readJsonData().toString();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: MyCustomScrollBehavior(),
        home: const MainWindow());
  }
}

Future<String> readJsonData() async {
  final configFile = File('assets/config/flutter_config.json');
  final jsonString = await configFile.readAsString();
  final dynamic jsonMap = jsonDecode(jsonString);
  print(jsonMap['path']);
  return jsonMap['path'];
}
