import 'package:flutibre/screens/book_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutibre/models/book.dart';
import 'package:flutibre/screens/mobil_view.dart';

class ResponsiveHomePage extends StatefulWidget {
  const ResponsiveHomePage({Key? key}) : super(key: key);

  @override
  State<ResponsiveHomePage> createState() => _ResponsiveHomePageState();
}

class _ResponsiveHomePageState extends State<ResponsiveHomePage> {
  Book? book;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var isWideLayout = constraints.maxWidth > 600;
      if (!isWideLayout) {
        return MobilView(
          onBookTapped: (book) {
            Navigator.pushNamed(
              context,
              '/BookDetailsPage',
              arguments: book,
            );
          },
        );
      } else {
        return Row(
          children: [
            Expanded(child: MobilView(
              onBookTapped: (book) {
                setState(() {
                  this.book = book;
                });
              },
            )),
            const VerticalDivider(
              color: Colors.cyan,
              thickness: 3,
              width: 3,
            ),
            SizedBox(
              width: 300,
              //TODO: Kell csinálni egy másik widgetet
              child: BookDetailsContent(
                book: book,
              ),
            ),
          ],
        );
      }
    });
  }
}
