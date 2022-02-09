import 'package:flutibre/utils/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutibre/models/book_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class GridPage extends StatelessWidget {
  const GridPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int size = MediaQuery.of(context).size.width.round();
    return Consumer<BookProvider>(builder: (context, value, listTile) {
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
                BookData book = value.books[index];
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
                            image: AssetImage(value.books[index].cover),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: value.books.length,
            );
          }));
    });
  }
}
