import 'package:flutibre/model/book.dart';
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
  String formats = "";
  String? _path;
  @override
  void initState() {
    super.initState();
    getPath();
  }

  @override
  Widget build(BuildContext context) {
    List<String> formats = [];
    for (var item in widget.book!.formats!) {
      formats.add(item.format.toLowerCase());
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.book!.title,
            style: Theme.of(context).textTheme.displayLarge,
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
                            Text(
                                'Formats: ${formats.toString().replaceAll('[', '').replaceAll(']', '')}',
                                style: Theme.of(context).textTheme.bodyLarge),
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
                                  backgroundColor: Colors.cyan,
                                ),
                                child: Text(
                                  'Back',
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  String bookPath = widget.book!.path
                                      .replaceAll(
                                          'cover.jpg',
                                          widget.book!.formats![0].name +
                                              '.' +
                                              widget.book!.formats![0].format
                                                  .toLowerCase())
                                      .replaceAll(
                                          'cover.png',
                                          widget.book!.formats![0].name +
                                              '.' +
                                              widget.book!.formats![0].format
                                                  .toLowerCase());
                                  if (Platform.isWindows) {
                                    OpenFilex.open(
                                        bookPath.replaceAll('/', '\\'));
                                  } else {
                                    OpenFilex.open(bookPath);
                                  }
                                },
                                style: TextButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  backgroundColor: Colors.cyan,
                                ),
                                child: Text(
                                  'Open',
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
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

  void getPath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _path = await prefs.getString('path');

    setState(() {
      _path;
    });
  }

  Image loadCover() {
    String path = widget.book!.path;
    return path != 'cover.jpg'
        ? Image.file(File(_path! + '/' + path + '/cover.jpg'))
        : Image.asset('images/cover.png');
  }

  Future<dynamic> deleteDialog(BuildContext context) {
    return showDialog(
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
  }

  Widget bookDetailElement(
      {required String detailType, required String detailContent}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(detailType,
            style: Theme.of(context).textTheme.displayMedium,
            overflow: TextOverflow.ellipsis),
        const VerticalDivider(),
        Flexible(
          child: Text(detailContent,
              style: Theme.of(context).textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
