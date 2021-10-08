import 'package:flutter/material.dart';
import 'package:flutibre/utils/scroll.dart';
import 'package:flutibre/models/girl.dart';
import 'package:flutibre/screens/details_page.dart';
import 'package:flutibre/utils/dataservice.dart';

class GridPage extends StatelessWidget {
  final DataService data = DataService();

  List<ImageDetails> get _images => data.getListGirls();

  @override
  Widget build(BuildContext context) {
    int size = MediaQuery.of(context).size.width.round();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tiles"),
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
            return RawMaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsPage(
                      imagePath: _images[index].imagePath,
                      title: _images[index].title,
                      photographer: _images[index].photographer,
                      price: _images[index].price,
                      details: _images[index].details,
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
                      image: AssetImage(_images[index].imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: _images.length,
        ),
      ),
    );
  }
}
