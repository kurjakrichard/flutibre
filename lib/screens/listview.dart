import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List"),
      ),
      body: const ListViewPage(),
    );
  }
}

class ListViewPage extends StatelessWidget {
  const ListViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int size = MediaQuery.of(context).size.width.round();

    return (Center(
        // Create a grid with columns fit to screen. If you change the scrollDirection to
        // horizontal, this produces rows.

        child: getListView()));
  }

  List<String> getListElement() {
    var items = List<String>.generate(100, (counter) => 'Item $counter');
    return items;
  }

  Widget getListView() {
    var listItems = getListElement();
    var listView = ListView.builder(itemBuilder: (context, index) {
      return ListTile(
        title: Text(listItems[index]),
      );
    });
    return listView;
  }
}
