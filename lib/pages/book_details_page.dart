import 'package:flutibre/providers/booklist_provider.dart';
import 'package:flutibre/providers/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore: depend_on_referenced_packages
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

    return BookDetailsContent(
      book: book,
    );
  }
}

class BookDetailsContent extends ConsumerStatefulWidget {
  const BookDetailsContent({Key? key, this.book, this.mainContext})
      : super(key: key);
  final BuildContext? mainContext;
  final Book? book;

  @override
  ConsumerState<BookDetailsContent> createState() => _BookDetailsContentState();
}

class _BookDetailsContentState extends ConsumerState<BookDetailsContent> {
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
              ConstrainedBox(
                constraints:
                    BoxConstraints.loose(const Size(double.minPositive, 400)),
                child: loadCover(),
              ),
              const SizedBox(
                height: 16,
              ),
              bookDetailElement(
                  detailType: '${AppLocalizations.of(context)!.title}: ',
                  detailContent: widget.book!.title),
              bookDetailElement(
                  detailType: '${AppLocalizations.of(context)!.author}: ',
                  detailContent: widget.book!.authors![0].name),
              const SizedBox(
                height: 8,
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Wrap(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        '${AppLocalizations.of(context)!.openbook}:  ',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    for (Data item in widget.book!.formats!)
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0, bottom: 16),
                        child: ElevatedButton(
                          style: ButtonStyle(minimumSize:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.disabled)) {
                              return const Size(65, 35);
                            }
                            return const Size(65, 35);
                          })),
                          onPressed: () {
                            String bookPath =
                                '${prefs.getString('path')}/${widget.book!.path}/${widget.book!.formats![0].name}.${item.format.toLowerCase()}';

                            OpenFilex.open(bookPath);
                          },
                          child: Text(
                            item.format.toLowerCase(),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                  ])),
              bookDetailElement(
                  detailType: '${AppLocalizations.of(context)!.comment}:  ',
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
            onPressed: () async {
              Navigator.pop(context);
              Directory dir = Directory(
                  '${ref.read(sharedPreferencesProvider).getString('path')!}/${widget.book!.path}');
              Directory parentDir = Directory(
                  '${ref.read(sharedPreferencesProvider).getString('path')!}/${widget.book!.path.split('/')[0]}');
              await dir.delete(recursive: true);
              bool isEmpty = await Directory(
                      '${ref.read(sharedPreferencesProvider).getString('path')!}/${widget.book!.path.split('/')[0]}')
                  .list()
                  .isEmpty;
              if (isEmpty) {
                parentDir.delete(recursive: true);
              }
              ref.read(bookListProvider.notifier).deleteBook(widget.book!.id);
              Navigator.maybePop(context);
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
