import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int size = MediaQuery.of(context).size.width.round();

    return Center(
      child: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.

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

void showSnackBar(BuildContext context, String item) {
  var snackBar = SnackBar(
    content: Text('You just tapped $item'),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        debugPrint(MediaQuery.of(context).size.width.toString());
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
