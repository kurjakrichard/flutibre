import 'package:flutibre/models/book_data.dart';
import 'package:flutibre/utils/book_repository.dart';
import 'package:flutter/material.dart';

class BookDetailsPage extends StatelessWidget {
  const BookDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic routeSettings = ModalRoute.of(context)!.settings;
    dynamic book = routeSettings.arguments as BookData;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          book.title,
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Are you sure?'),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: const Text('Delete'),
                      onPressed: () {
                        Navigator.pop(context);
                        BookRepository.of(context).onDeleteBook(book.id);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  image: DecorationImage(
                    image: AssetImage(book.cover),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 260,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        BookDetailElement(
                            detailType: 'Title:', detailContent: book.title),
                        BookDetailElement(
                            detailType: 'Author:', detailContent: book.author),
                        BookDetailElement(
                            detailType: 'Language:',
                            detailContent: book.language),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          book.content,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: Colors.cyan,
                            ),
                            child: Text(
                              'Back',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: Colors.cyan,
                            ),
                            child: Text(
                              'Open',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookDetailElement extends StatelessWidget {
  final String detailType;
  final String detailContent;

  const BookDetailElement(
      {Key? key, required this.detailType, required this.detailContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(detailType, style: Theme.of(context).textTheme.headline2),
        const VerticalDivider(),
        Text(detailContent, style: Theme.of(context).textTheme.bodyText1),
      ],
    );
  }
}
