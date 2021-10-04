import 'package:flutter/material.dart';
import 'package:flutibre/utils/scroll.dart';
import 'package:flutibre/models/girl.dart';
import 'package:flutibre/screens/details_page.dart';

class GridPage extends StatelessWidget {
  List<ImageDetails> _images = [
    ImageDetails(
      imagePath: 'images/1.jpg',
      price: '\$20.00',
      photographer: 'Martin Andres',
      title: 'New Year',
      details:
          'This image was taken during a party in New York on new years eve. Quite a colorful shot.',
    ),
    ImageDetails(
      imagePath: 'images/2.jpg',
      price: '\$10.00',
      photographer: 'Abraham Costa',
      title: 'Spring',
      details:
          'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nihil error aspernatur, sequi inventore eligendi vitae dolorem animi suscipit. Nobis, cumque.',
    ),
    ImageDetails(
      imagePath: 'images/3.jpg',
      price: '\$30.00',
      photographer: 'Jamie Bryan',
      title: 'Casual Look',
      details:
          'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nihil error aspernatur, sequi inventore eligendi vitae dolorem animi suscipit. Nobis, cumque.',
    ),
    ImageDetails(
      imagePath: 'images/4.jpg',
      price: '\$20.00',
      photographer: 'Jamie Bryan',
      title: 'New York',
      details:
          'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nihil error aspernatur, sequi inventore eligendi vitae dolorem animi suscipit. Nobis, cumque.',
    ),
    ImageDetails(
      imagePath: 'images/5.jpg',
      price: '\$20.00',
      photographer: 'Jamie Bryan',
      title: 'New York',
      details:
          'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nihil error aspernatur, sequi inventore eligendi vitae dolorem animi suscipit. Nobis, cumque.',
    ),
    ImageDetails(
      imagePath: 'images/6.jpg',
      price: '\$20.00',
      photographer: 'Jamie Bryan',
      title: 'New York',
      details:
          'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nihil error aspernatur, sequi inventore eligendi vitae dolorem animi suscipit. Nobis, cumque.',
    ),
    ImageDetails(
      imagePath: 'images/7.jpg',
      price: '\$20.00',
      photographer: 'Jamie Bryan',
      title: 'New York',
      details:
          'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nihil error aspernatur, sequi inventore eligendi vitae dolorem animi suscipit. Nobis, cumque.',
    ),
    ImageDetails(
      imagePath: 'images/8.jpg',
      price: '\$20.00',
      photographer: 'Jamie Bryan',
      title: 'New York',
      details:
          'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nihil error aspernatur, sequi inventore eligendi vitae dolorem animi suscipit. Nobis, cumque.',
    ),
    ImageDetails(
      imagePath: 'images/9.jpg',
      price: '\$20.00',
      photographer: 'Jamie Bryan',
      title: 'New York',
      details:
          'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nihil error aspernatur, sequi inventore eligendi vitae dolorem animi suscipit. Nobis, cumque.',
    ),
    ImageDetails(
      imagePath: 'images/10.jpg',
      price: '\$20.00',
      photographer: 'Jamie Bryan',
      title: 'New York',
      details:
          'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nihil error aspernatur, sequi inventore eligendi vitae dolorem animi suscipit. Nobis, cumque.',
    ),
    ImageDetails(
      imagePath: 'images/11.jpg',
      price: '\$20.00',
      photographer: 'Jamie Bryan',
      title: 'New York',
      details:
          'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nihil error aspernatur, sequi inventore eligendi vitae dolorem animi suscipit. Nobis, cumque.',
    ),
    ImageDetails(
      imagePath: 'images/12.jpg',
      price: '\$20.00',
      photographer: 'Jamie Bryan',
      title: 'New York',
      details:
          'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nihil error aspernatur, sequi inventore eligendi vitae dolorem animi suscipit. Nobis, cumque.',
    ),
    ImageDetails(
      imagePath: 'images/13.jpg',
      price: '\$20.00',
      photographer: 'Jamie Bryan',
      title: 'New York',
      details:
          'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nihil error aspernatur, sequi inventore eligendi vitae dolorem animi suscipit. Nobis, cumque.',
    ),
    ImageDetails(
      imagePath: 'images/14.jpg',
      price: '\$20.00',
      photographer: 'Matthew',
      title: 'Cone Ice Cream',
      details:
          'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nihil error aspernatur, sequi inventore eligendi vitae dolorem animi suscipit. Nobis, cumque.',
    ),
    ImageDetails(
      imagePath: 'images/15.jpg',
      price: '\$25.00',
      photographer: 'Martin Sawyer',
      title: 'Pink Ice Cream',
      details:
          'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nihil error aspernatur, sequi inventore eligendi vitae dolorem animi suscipit. Nobis, cumque.',
    ),
    ImageDetails(
      imagePath: 'images/16.jpg',
      price: '\$15.00',
      photographer: 'John Doe',
      title: 'Strawberry Ice Cream',
      details:
          'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nihil error aspernatur, sequi inventore eligendi vitae dolorem animi suscipit. Nobis, cumque.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    int size = MediaQuery.of(context).size.width.round();
    return Scaffold(
      appBar: AppBar(
        title: Text("Tiles"),
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
