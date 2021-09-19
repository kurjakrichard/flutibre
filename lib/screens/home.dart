import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      alignment: Alignment.center,
      color: Colors.deepPurple,
      margin: const EdgeInsets.all(10.0),
      child: const Text(
        'Flight',
        textDirection: TextDirection.ltr,
        style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: 75.0,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            color: Colors.deepOrange),
      ),
    ));
  }
}
