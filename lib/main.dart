import 'package:flutibre/screens/gridview.dart';
import 'package:flutibre/screens/listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';

void main() => runApp(const MaterialApp(
      home: Flutibre(),
      debugShowCheckedModeBanner: false,
    ));

class Flutibre extends StatelessWidget {
  const Flutibre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Flutibre'),
          ),
          body: Center(
            child: GridPage(),
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
