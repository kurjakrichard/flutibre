import 'package:flutter/material.dart';
import 'package:flutibre/utils/scroll.dart';

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

    return (MaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: MyCustomScrollBehavior(),
        // Create a grid with columns fit to screen. If you change the scrollDirection to
        // horizontal, this produces rows.

        home: getListView()));
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
