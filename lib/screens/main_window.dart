import 'package:flutibre/models/book_data.dart';
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
      body: Builder(builder: (context) {
        return ListView.separated(
          cacheExtent: 0,
          itemBuilder: (context, index) {
            var book = repository.books[index];
            return BookElement(
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
                  '/book/${book.id}',
                  arguments: book,
                );
              },
            );
          },
          padding: const EdgeInsets.symmetric(horizontal: 10),
          separatorBuilder: (context, index) => const Divider(
            height: 6,
            color: Colors.transparent,
          ),
          itemCount: repository.books.length,
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.cyan,
        onPressed: () {
          Navigator.pushNamed(context, '/AddBookPage',
              arguments: {'size': repository.books.length});
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
                  style: Theme.of(context).textTheme.headline1,
                ),
                hoverColor: hovercolor,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    '/ListPage',
                    arguments: repository.books,
                  );
                },
              ),
              ListTile(
                title: Text(
                  "Tiles",
                  style: Theme.of(context).textTheme.headline1,
                ),
                hoverColor: hovercolor,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    '/GridPage',
                    arguments: repository.books,
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
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),

        leading: Image(image: AssetImage(book.cover)),
        //Image.file(File(book.cover),),
        title: Text(
          book.author,
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
