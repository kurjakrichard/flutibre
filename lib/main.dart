import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
      title: "Flutibre",
      home: Material(
          color: Colors.lightBlueAccent,
          child: Center(
              child: Text(
            "Hello Flutibre",
            textDirection: TextDirection.ltr,
          )))));
}
