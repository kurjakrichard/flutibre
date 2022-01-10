import 'package:flutibre/screens/gridview.dart';
import 'package:flutibre/screens/listview.dart';
import 'package:flutter/material.dart';

class MainWindow extends StatelessWidget {
  const MainWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutibre'),
        backgroundColor: const Color.fromRGBO(98, 163, 191, 1),
      ),
      body: Column(
        children: [BookList(), BookList(), BookList()],
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
          title: const Text('Ricsi'),
          subtitle: Text('Programozó'),
          tileColor: Color.fromRGBO(98, 163, 191, 0.5),
        ));
  }
}
