import 'package:flutter/material.dart';

class GridPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tiles"),
      ),
      body: GridListView(),
    );
  }
}

class GridListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int size = MediaQuery.of(context).size.width.round();

    return Center(
      child: GridView.count(
        // Create a grid with columns fit to screen. If you change the scrollDirection to
        // horizontal, this produces rows.

        crossAxisCount: (size / 200).round(),
        // Generate 100 widgets that display their index in the List.
        children: List.generate(100, (index) {
          return Center(
            child: Text(
              'Item $index',
              style: Theme.of(context).textTheme.headline5,
            ),
          );
        }),
      ),
    );
  }
}
