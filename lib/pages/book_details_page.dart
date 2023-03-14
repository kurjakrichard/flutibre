import 'package:flutter/material.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:open_filex/open_filex.dart';
import 'package:html/parser.dart';
import 'dart:io';
import '../main.dart';
import '../model/book.dart';
import '../model/data.dart';

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
    String bookPath = book!.has_cover == 1
        ? '${prefs.getString('path')}/${book!.path}/cover.jpg'
        : 'images/cover.png';
    Size size;
    try {
      size = ImageSizeGetter.getSize(FileInput(File(bookPath)));
    } on UnsupportedError {
      size = const Size(200, 500);
    }
    var height = size.height.toDouble();
    {
      return BookDetailsContent(
        book: book,
        height: height,
      );
    }
  }
}

// ignore: must_be_immutable
class BookDetailsContent extends StatefulWidget {
  BookDetailsContent({Key? key, this.book, required this.height})
      : super(key: key);
  final Book? book;
  double height;

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
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            children: [
              SizedBox(
                  height: widget.height > 500 ? 500 : widget.height,
                  child: loadCover()),
              const SizedBox(
                height: 16,
              ),
              bookDetailElement(
                  detailType: 'Title: ', detailContent: widget.book!.title),
              bookDetailElement(
                  detailType: 'Author: ',
                  detailContent: widget.book!.authors![0].name),
              const SizedBox(
                height: 8,
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Wrap(children: [
                    const Text(
                      'Open formats: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    for (Data item in widget.book!.formats!)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            String bookPath =
                                '${prefs.getString('path')}/${widget.book!.path}/${widget.book!.formats![0].name}.${item.format.toLowerCase()}';

                            OpenFilex.open(bookPath);
                          },
                          child: Text(
                            item.format.toLowerCase(),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                  ])),
              bookDetailElement(
                  detailType: 'Comment: ',
                  detailContent:
                      parse(widget.book!.comment!.text).documentElement?.text ??
                          ''),
            ],
          ),
        ));
  }

  Image loadCover() {
    int hasCover = widget.book!.has_cover;
    String path = widget.book!.path;
    String bookPath = '${prefs.getString('path')}/$path/cover.jpg';

    return hasCover == 1
        ? Image.file(
            File(bookPath),
            height: 600,
          )
        : Image.asset('images/cover.png', fit: BoxFit.contain);
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
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            detailType,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(detailContent, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
