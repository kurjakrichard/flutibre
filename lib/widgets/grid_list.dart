import 'package:flutibre/providers/selected_book_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data_export.dart';

class GridList extends ConsumerWidget {
  const GridList({super.key, required this.books, this.count = 1});
  final List<Book> books;
  final double count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int size = MediaQuery.of(context).size.width.round();
    //app bar

    ///create book tile hero
    createTile(Book book) => Hero(
          tag: book.title,
          child: Material(
            elevation: 15.0,
            shadowColor: Colors.yellow.shade900,
            child: InkWell(
              onTap: () {
                ref.read(selectedBookProvider.notifier).setSelectedBook(book);
                print(book);
                // Navigator.pushNamed(context, 'detail/${book.title}');
              },
              child: Image(
                image: AssetImage(book.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );

    ///create book grid tiles
    final grid = CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.all(16.0),
          sliver: SliverGrid.count(
            childAspectRatio: 2 / 3,
            crossAxisCount: (size / 150 / count).round(),
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            children: books.map((book) => createTile(book)).toList(),
          ),
        )
      ],
    );

    return grid;
  }
}
