import 'package:flutibre/screens/gridview.dart';
import 'package:flutibre/screens/listview.dart';
import 'package:flutter/material.dart';

class MainWindow extends StatelessWidget {
  const MainWindow({Key? key}) : super(key: key);
  final color = Colors.white;
  final hovercolor = Colors.white70;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutibre',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: Column(
        children: const [BookList(), BookList(), BookList()],
      ),
      backgroundColor: Colors.cyan[50],
      drawer: Drawer(
        child: Material(
          color: const Color.fromRGBO(98, 163, 191, 0.5),
          child: ListView(
            children: <Widget>[
              // ignore: prefer_const_constructors
              DrawerHeader(
                child: Text(
                  "Navigation",
                  style: Theme.of(context).textTheme.headline1,
                ),
                decoration: const BoxDecoration(color: Colors.cyan),
              ),
              ListTile(
                title: Text(
                  "List",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                hoverColor: hovercolor,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListPage()),
                  );
                },
              ),
              ListTile(
                title: Text(
                  "Tiles",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                hoverColor: hovercolor,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GridPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookList extends StatelessWidget {
  const BookList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: ListTile(
          leading: Image.network(
            'https://randomuser.me/api/portraits/men/71.jpg',
          ),
          title: Text(
            'Ricsi',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          subtitle: Text(
            'Programozó',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          tileColor: const Color.fromRGBO(98, 163, 191, 0.5),
        ));
  }
}
