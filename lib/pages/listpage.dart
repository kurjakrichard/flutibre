import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../model/booklist_item.dart';

class ListPage extends ConsumerWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<BookListItem>> itemValue = ref.watch(booklistProvider);
    return itemValue.when(
      data: (item) => ListView.builder(
          itemCount: item.length,
          itemBuilder: (context, index) => ListTile(
                title: Text(item[index].title),
              )),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text(e.toString())),
    );
  }
}
