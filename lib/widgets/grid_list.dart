import 'dart:io';
import 'package:flutibre/providers/book/book_export.dart';
import 'package:flutibre/providers/selected_book_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';

import '../config/config.dart';
import '../data/data_export.dart';
import '../utils/utils.dart';

class GridList extends ConsumerWidget {
  const GridList({super.key, this.count = 1});

  final double count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Book> books = ref.watch(booksProvider).books;
    int size = MediaQuery.of(context).size.width.round();

    ///create book tile hero
    createTile(Book book) => Hero(
          tag: book.id.toString(),
          child: Material(
            elevation: 15.0,
            shadowColor: Colors.yellow.shade900,
            child: InkWell(
              onDoubleTap: () {
                ref.read(selectedBookProvider.notifier).setSelectedBook(book);
                showDialog(
                    context: context,
                    builder: (_) {
                      return SimpleDialog(
                        //title: const Text("Dialog Title"),
                        children: [
                          SimpleDialogOption(
                            child: TextButton(
                                onPressed: () {
                                  OpenFilex.open(
                                      '/home/sire/Dokumentumok/ebooks/${book.path}/${book.filename}.${book.format}');
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Megnyitás',
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.start)),
                          ),
                          SimpleDialogOption(
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  context.push(RouteLocation.updateBook);
                                },
                                child: const Text('Szerkesztés',
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.start)),
                          ),
                          SimpleDialogOption(
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  context.push(RouteLocation.bookDetails);
                                },
                                child: const Text('Részletek',
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.start)),
                          ),
                          SimpleDialogOption(
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  AppAlerts.showAlertDeleteDialog(
                                      context: context, ref: ref, book: book);
                                  /* ref
                                      .read(booksProvider.notifier)
                                      .deleteBook(book);
                                  */
                                },
                                child: const Text('Törlés',
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.start)),
                          ),
                        ],
                      );
                    });
              },
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return const AlertDialog(
                        title: Text("Dialog Title"),
                        content: Text("This is the dialog content."),
                      );
                    });
              },
              onTap: () async {
                ref.read(selectedBookProvider.notifier).setSelectedBook(book);
                String path = '/home/sire/vscode/flutibre/${book.image}';

                File image =
                    File(path); // Or any other way to get a File instance.
                var decodedImage =
                    await decodeImageFromList(image.readAsBytesSync());
                // ignore: avoid_print
                print(decodedImage.width);
                // ignore: avoid_print
                print(decodedImage.height);
                // ignore: use_build_context_synchronously
                Navigator.of(context).canPop();
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
          padding: const EdgeInsets.all(16.0),
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
