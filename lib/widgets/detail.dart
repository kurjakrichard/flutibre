import 'package:flutibre/providers/selected_book_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/data_export.dart';
import 'rating_bar.dart';
import 'package:flutter/material.dart';

class Detail extends ConsumerWidget {
  const Detail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Book? selectedBook = ref.watch(selectedBookProvider.notifier).state;

    return selectedBook != null
        ? ListView(
            children: <Widget>[
              topContent(selectedBook!),
              bottomContent(selectedBook)
            ],
          )
        : const Text('Nincs könyv kiválasztva');
  }

  Container topContent(Book selectedBook) {
    return Container(
      // color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(flex: 2, child: topLeft(selectedBook!)),
          Flexible(flex: 3, child: topRight(selectedBook!)),
        ],
      ),
    );
  }

  ///scrolling text description
  SizedBox bottomContent(Book selectedBook) {
    return SizedBox(
      height: 220.0,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          selectedBook!.description,
          style: const TextStyle(fontSize: 13.0, height: 1.5),
        ),
      ),
    );
  }

  ///detail top right
  Column topRight(Book selectedBook) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        text(selectedBook.title,
            size: 16, isBold: true, padding: const EdgeInsets.only(top: 16.0)),
        text(
          'by ${selectedBook.writer}',
          color: Colors.black54,
          size: 12,
          padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
        ),
        text(
          selectedBook.price,
          isBold: true,
          padding: const EdgeInsets.only(right: 8.0),
        ),
        RatingBar(rating: selectedBook.rating),
        const SizedBox(height: 32.0),
        Material(
          borderRadius: BorderRadius.circular(20.0),
          shadowColor: Colors.blue.shade200,
          elevation: 5.0,
          child: MaterialButton(
            onPressed: () {},
            minWidth: 160.0,
            color: Colors.blue,
            child: text('BUY IT NOW', color: Colors.white, size: 13),
          ),
        )
      ],
    );
  }

  ///detail of book image and it's pages
  Column topLeft(Book selectedBook) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Hero(
            tag: selectedBook!.title,
            child: Material(
              elevation: 15.0,
              shadowColor: Colors.yellow.shade900,
              child: Image(
                image: AssetImage(selectedBook!.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        text('${selectedBook!.pages} pages', color: Colors.black38, size: 12)
      ],
    );
  }

  ///create text widget
  Padding text(String data,
          {Color color = Colors.black87,
          num size = 14,
          EdgeInsetsGeometry padding = EdgeInsets.zero,
          bool isBold = false}) =>
      Padding(
        padding: padding,
        child: Text(
          data,
          style: TextStyle(
              color: color,
              fontSize: size.toDouble(),
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
      );
}
