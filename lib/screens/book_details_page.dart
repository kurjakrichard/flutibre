import 'package:flutibre/models/book_data.dart';
import 'package:flutibre/utils/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class BookDetailsPage extends StatelessWidget {
  const BookDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var routeSettings = ModalRoute.of(context)!.settings;
    var book = routeSettings.arguments as BookData;
    {
      return BookDetailsContent(
        book: book,
      );
    }
    ;
  }
}

class BookDetailsContent extends StatelessWidget {
  const BookDetailsContent({Key? key, this.book}) : super(key: key);
  final BookData? book;

  @override
  Widget build(BuildContext context) {
    if (book == null) {
      return const Scaffold();
    }
    return Consumer<BookProvider>(builder: (context, value, listTile) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            book!.title,
            style: Theme.of(context).textTheme.headline1,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
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
                        onPressed: () {
                          Navigator.pop(context);
                          value.onDelete(book!.id);
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
                      image: AssetImage(book!.cover),
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
                              detailType:
                                  '${AppLocalizations.of(context)!.title}:',
                              detailContent: book!.title),
                          BookDetailElement(
                              detailType:
                                  '${AppLocalizations.of(context)!.author}:',
                              detailContent: book!.author),
                          BookDetailElement(
                              detailType:
                                  '${AppLocalizations.of(context)!.language}:',
                              detailContent: book!.language),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            book!.content,
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
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
    });
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
