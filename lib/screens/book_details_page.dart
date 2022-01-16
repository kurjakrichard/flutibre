import 'package:flutibre/models/book_data.dart';
import 'package:flutter/material.dart';

class BookDetailsPage extends StatelessWidget {
  const BookDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var routeSettings = ModalRoute.of(context)!.settings;
    var book = routeSettings.arguments as BookData;
    return Scaffold(
      appBar: AppBar(
          title: Text(
        book.title,
        style: Theme.of(context).textTheme.headline1,
      )),
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
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Title:  ${book.title}',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            'Author:  ${book.author}',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            'Language:  ${book.language}',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            'Content:  ${book.content}',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
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
                            style: Theme.of(context).textTheme.subtitle1,
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
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                      ),
                    ],
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
