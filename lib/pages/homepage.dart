import 'package:flutibre/pages/listpage.dart';
import 'package:flutter/material.dart';
import 'package:flutibre/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(bookListProvider).toggleAllBooks();

          // ignore: unused_result
          ref.refresh(booklistProvider).isLoading;
        },
        child: const Icon(Icons.add),
      ),
      body: ListPage(),
    );
  }
}
