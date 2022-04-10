import 'package:flutibre/models/book.dart';
import 'package:flutibre/utils/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class MobilView extends StatelessWidget {
  const MobilView({Key? key, required this.onBookTapped}) : super(key: key);

  final void Function(Book) onBookTapped;
  final color = Colors.white;
  final hovercolor = const Color.fromRGBO(98, 163, 191, 1);

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(builder: (context, value, listTile) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Flutibre',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        body: ListView.separated(
          cacheExtent: 0,
          itemBuilder: (context, index) {
            var book = value.books[index];
            return BookElement(
              book: Book(
                book.id,
                book.author_sort,
                book.title,
                book.series_index,
                book.path,
              ),
              onTap: () {
                onBookTapped(book);
              },
            );
          },
          padding: const EdgeInsets.symmetric(horizontal: 10),
          separatorBuilder: (context, index) => const Divider(
            height: 6,
            color: Colors.transparent,
          ),
          itemCount: value.books.length,
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Colors.cyan,
          tooltip: AppLocalizations.of(context)!.addbook,
          onPressed: () {
            Navigator.pushNamed(context, '/AddBookPage',
                arguments: {'size': value.books.length});
          },
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
                          AppLocalizations.of(context)!.navigation,
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
                    AppLocalizations.of(context)!.list,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  hoverColor: hovercolor,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      '/ListPage',
                      arguments: value.books,
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.tiles,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  hoverColor: hovercolor,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      '/GridPage',
                      arguments: value.books,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class BookElement extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookElement({Key? key, required this.book, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),

        leading: Image(image: AssetImage(book.path)),
        //Image.file(File(book.cover),),
        title: Text(
          book.author_sort,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        subtitle: Text(
          book.title,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        tileColor: const Color.fromRGBO(98, 163, 191, 0.5),
      ),
    );
  }
}
