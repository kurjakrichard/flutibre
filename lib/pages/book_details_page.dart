import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import '../main.dart';
import '../model/book.dart';

// ignore: must_be_immutable
class BookDetailsPage extends StatelessWidget {
  BookDetailsPage({Key? key, this.book}) : super(key: key);
  Book? book;
  @override
  Widget build(BuildContext context) {
    var routeSettings = ModalRoute.of(context)!.settings;

    if (routeSettings.arguments != null) {
      book = routeSettings.arguments as Book;
    }

    {
      return BookDetailsContent(
        book: book,
      );
    }
  }
}

class BookDetailsContent extends StatefulWidget {
  const BookDetailsContent({Key? key, this.book}) : super(key: key);
  final Book? book;

  @override
  State<BookDetailsContent> createState() => _BookDetailsContentState();
}

class _BookDetailsContentState extends State<BookDetailsContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.book!.title,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                deleteDialog(context);
              },
            ),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: loadCover(),
                ),
                SizedBox(
                  height: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            bookDetailElement(
                                detailType: 'Title:',
                                detailContent: widget.book!.title),
                            bookDetailElement(
                                detailType: 'Author:',
                                detailContent: widget.book!.author_sort),
                            const Text(
                              'Formats: ',
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                ),
                                child: const Text(
                                  'Back',
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  String bookPath =
                                      '${prefs.getString('path')}/${widget.book!.path}/${widget.book!.formats![0].name}.${widget.book!.formats![0].format.toLowerCase()}';
                                  OpenFilex.open(bookPath);
                                },
                                style: TextButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                ),
                                child: const Text(
                                  'Open',
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
            )));
  }

  Image loadCover() {
    int hasCover = widget.book!.has_cover;
    String path = widget.book!.path;
    String bookPath = '${prefs.getString('path')}/$path/cover.jpg';
    return hasCover == 1
        ? Image.file(File(bookPath))
        : Image.asset('images/cover.png');
  }

  Future<dynamic> deleteDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Want to delete'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.pop(context);
              // ignore: todo
              //TODO
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget bookDetailElement(
      {required String detailType, required String detailContent}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(detailType, overflow: TextOverflow.ellipsis),
        const VerticalDivider(),
        Flexible(
          child: Text(detailContent, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
