import 'package:flutter/material.dart';
import 'package:flutibre/utils/scroll.dart';
import 'package:flutibre/models/book_data.dart';
import 'package:flutibre/screens/book_details_page.dart';

class GridPage extends StatelessWidget {
  GridPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var routeSettings = ModalRoute.of(context)!.settings;
    var books = routeSettings.arguments as List<BookData>;
    int size = MediaQuery.of(context).size.width.round();
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        title: Text(
          "Tiles",
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: Container(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (size / 200).round(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            BookData book = books[index];
            return Center(
              child: RawMaterialButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/book/${book.id}',
                    arguments: book,
                  );
                },
                child: Hero(
                  tag: 'logo$index',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: AssetImage(books[index].cover),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: books.length,
        ),
      ),
    );
  }
}
