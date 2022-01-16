import 'dart:io';
import 'package:flutibre/models/book_data.dart';
import 'package:flutibre/screens/book_details_page.dart';
import 'package:flutibre/screens/gridview.dart';
import 'package:flutibre/screens/listview.dart';
import 'package:flutibre/utils/book_repository.dart';
import 'package:flutter/material.dart';

class MainWindow extends StatelessWidget {
  const MainWindow({Key? key}) : super(key: key);
  final color = Colors.white;
  final hovercolor = const Color.fromRGBO(98, 163, 191, 1);

  @override
  Widget build(BuildContext context) {
    var repository = BookRepository.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutibre',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: SingleChildScrollView(
        child: Builder(builder: (context) {
          return Column(
            children: [
              for (var book in repository.books)
                BookElement(
                  book: BookData(
                    book.id,
                    book.author,
                    book.title,
                    book.series,
                    book.language,
                    book.publisher,
                    book.content,
                    book.cover,
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/bookDetails',
                      arguments: book,
                    );
                  },
                )
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.cyan,
        onPressed: () {},
      ),
      drawer: Drawer(
        child: Material(
          color: const Color.fromRGBO(98, 163, 191, 0.5),
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Navigation",
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      const FlutterLogo(
                        size: 40,
                      )
                    ]),
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
                    MaterialPageRoute(
                        builder: (context) =>
                            ListPage(books: repository.books)),
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
                    MaterialPageRoute(
                        builder: (context) =>
                            GridPage(books: repository.books)),
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

class BookElement extends StatelessWidget {
  final BookData book;
  final VoidCallback onTap;

  const BookElement({Key? key, required this.book, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: ListTile(
            leading: Image.file(
              File(book.cover),
            ),
            title: Text(
              book.author,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            subtitle: Text(
              book.title,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            tileColor: const Color.fromRGBO(98, 163, 191, 0.5),
          )),
    );
  }
}
