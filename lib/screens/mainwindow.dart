import 'package:flutibre/screens/settingspage.dart';
import 'package:flutter/material.dart';

class MainWindow extends StatelessWidget {
  const MainWindow({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerNavigation(context),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: () {}),
      appBar: AppBar(
        title: Text('Flutibre'),
      ),
    );
  }

  Widget DrawerNavigation(context) {
    return Drawer(
      child: ListView(children: [
        DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Image.asset('images/bookshelf-icon.png')),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Main window'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => MainWindow()));
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings page'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SettingsPage()));
          },
        )
      ]),
    );
  }
}
