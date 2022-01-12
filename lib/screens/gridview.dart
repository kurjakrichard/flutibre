import 'package:flutter/material.dart';
import 'package:flutibre/utils/scroll.dart';
import 'package:flutibre/models/book.dart';
import 'package:flutibre/screens/details_page.dart';
import 'package:flutibre/utils/dataservice.dart';

class GridPage extends StatelessWidget {
  GridPage({Key? key}) : super(key: key);

  final DataService data = DataService();
  List<Book> get _books => data.getListBooks();

  @override
  Widget build(BuildContext context) {
    int size = MediaQuery.of(context).size.width.round();
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        title: Text(
          "Tiles",
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: MaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: MyCustomScrollBehavior(),
        home: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (size / 200).round(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return Center(
              child: RawMaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(
                        author: _books[index].author,
                        title: _books[index].title,
                        imagePath: _books[index].path,
                        index: index,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: 'logo$index',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: AssetImage(_books[index].path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: _books.length,
        ),
      ),
    );
  }
}
