import 'package:flutibre/screens/gridview.dart';
import 'package:flutibre/screens/listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

void main() => runApp(const MaterialApp(
      home: Flutibre(),
      debugShowCheckedModeBanner: false,
    ));

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

class Flutibre extends StatelessWidget {
  const Flutibre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Flutibre'),
          ),
          body: const Center(
            child: Text('Welcome to The Flutibre!'),
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  child: const Text("Navigation"),
                  decoration: BoxDecoration(color: Colors.grey[700]),
                ),
                ListTile(
                  title: const Text("List"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListPage()),
                    );
                  },
                ),
                ListTile(
                  title: const Text("Tiles"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GridPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
