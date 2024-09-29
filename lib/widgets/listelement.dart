import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/data.dart';

class ListElement extends ConsumerWidget {
  const ListElement({super.key, required this.books});

  final List<Book> books;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: books.isEmpty
            ? ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      onTap: () async {},
                      style: ListTileStyle.drawer,
                      title: Text(books[index].title),
                      subtitle: Text(books[index].note),
                      trailing: Text(books[index].time),
                    ),
                  );
                })
            : const Center(
                child: Text(
                  'List has no data',
                  style: TextStyle(fontSize: 35, color: Colors.black),
                ),
              ));
  }
}
