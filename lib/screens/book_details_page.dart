import 'package:flutibre/models/book.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../utils/ebook_service.dart';

class BookDetailsPage extends StatelessWidget {
  const BookDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var routeSettings = ModalRoute.of(context)!.settings;
    var book = routeSettings.arguments as Book;
    {
      return BookDetailsContent(
        book: book,
      );
    }
  }
}

class BookDetailsContent extends StatefulWidget {
  BookDetailsContent({Key? key, this.book}) : super(key: key);
  final Book? book;

  @override
  State<BookDetailsContent> createState() => _BookDetailsContentState();
}

class _BookDetailsContentState extends State<BookDetailsContent> {
  EbookService _bookService = EbookService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.book!.title,
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Want to delete'),
                  actions: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.pop(context);
                        _bookService.deleteBook(widget.book!.id);
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
              child: Image.file(File(widget.book!.path)),
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
                            detailType: 'Title:',
                            detailContent: widget.book!.title),
                        BookDetailElement(
                            detailType: 'Author:',
                            detailContent: widget.book!.author_sort),
                        const SizedBox(
                          height: 8,
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
                            onPressed: () {
                              if (Platform.isWindows) {
                                OpenFilex.open(
                                    widget.book!.path.replaceAll('/', '\\'));
                              } else {
                                OpenFilex.open(widget.book!.path);
                              }
                            },
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

String coverPath(String path) {
  return File(path).existsSync() ? path : 'images/cover.jpg';
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
