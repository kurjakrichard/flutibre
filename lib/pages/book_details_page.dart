import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore: depend_on_referenced_packages
import 'package:html/parser.dart';
import 'dart:io';
import '../main.dart';
import '../model/author.dart';
import '../model/book.dart';
import '../model/data.dart';
import '../providers/booklist_provider.dart';
import '../providers/shared_preferences_provider.dart';

class BookDetailsPage extends ConsumerStatefulWidget {
  const BookDetailsPage({Key? key, this.book}) : super(key: key);
  final Book? book;

  @override
  ConsumerState<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends ConsumerState<BookDetailsPage> {
  Book? book;

  @override
  Widget build(BuildContext context) {
    var routeSettings = ModalRoute.of(context)!.settings;
    if (routeSettings.arguments != null) {
      book = routeSettings.arguments as Book;
    } else {
      book = widget.book;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            book!.title,
          ),
          actions: [
            IconButton(
              tooltip: AppLocalizations.of(context)!.editbook,
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, '/editpage', arguments: book!);
              },
            ),
            IconButton(
              tooltip: AppLocalizations.of(context)!.deletebook,
              icon: const Icon(Icons.delete),
              onPressed: () {
                deleteDialog(context, ref);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            children: [
              loadCover(),
              const SizedBox(
                height: 16,
              ),
              bookDetailElement(
                  detailType: '${AppLocalizations.of(context)!.title}: ',
                  detailContent: book!.title),
              bookDetailElement(
                  detailType: '${AppLocalizations.of(context)!.author}: ',
                  detailContent: authors(book!.authors!)),
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
                    for (Data item in book!.formats!)
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0, bottom: 16),
                        child: ElevatedButton(
                          style: ButtonStyle(minimumSize:
                              WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.disabled)) {
                              return const Size(65, 35);
                            }
                            return const Size(65, 35);
                          })),
                          onPressed: () {
                            String bookPath =
                                '${prefs.getString('path')}/${book!.path}/${book!.formats![0].name}.${item.format.toLowerCase()}';

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
                      parse(book!.comment!.text).documentElement?.text ?? ''),
            ],
          ),
        ));
  }

  String authors(List<Author>? authors) {
    String items = authors![0].name;
    if (authors.length > 1) {
      for (var i = 1; i < authors.length; i++) {
        items = '$items, ${authors[i].name}';
      }
    }
    return items;
  }

  Image loadCover() {
    int hasCover = book!.has_cover;
    String path = book!.path;
    String bookPath = '${prefs.getString('path')}/$path/cover.jpg';

    return hasCover == 1
        ? Image.file(
            File(bookPath),
            height: 400,
            fit: BoxFit.fitHeight,
          )
        : Image.asset(
            'images/cover.png',
            fit: BoxFit.fitHeight,
            height: 400,
          );
  }

  Future<dynamic> deleteDialog(BuildContext context, WidgetRef ref) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.wanttodelete),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.ok),
            onPressed: () async {
              Navigator.pop(context);
              Directory dir = Directory(
                  '${ref.read(sharedPreferencesProvider).getString('path')!}/${book!.path}');
              Directory parentDir = Directory(
                  '${ref.read(sharedPreferencesProvider).getString('path')!}/${book!.path.split('/')[0]}');
              await dir.delete(recursive: true);
              bool isEmpty = await Directory(
                      '${ref.read(sharedPreferencesProvider).getString('path')!}/${book!.path.split('/')[0]}')
                  .list()
                  .isEmpty;
              if (isEmpty) {
                parentDir.delete(recursive: true);
              }
              await ref.read(bookListProvider.notifier).deleteBook(book);
              // ignore: use_build_context_synchronously
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
