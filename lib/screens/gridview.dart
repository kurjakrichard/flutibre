import 'package:flutibre/utils/book_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutibre/models/book_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GridPage extends StatelessWidget {
  const GridPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var repository = BookRepository.of(context);
    var books = repository.books;
    int size = MediaQuery.of(context).size.width.round();
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.tiles,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: Builder(builder: (context) {
        return GridView.builder(
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
                    '/BookDetailsPage',
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
        );
      }),
    );
  }
}
