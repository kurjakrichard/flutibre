import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../main.dart';
import '../model/booklist_item.dart';

class ListPage extends ConsumerWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<BookListItem>> itemValue = ref.watch(booklistProvider);
    return itemValue.when(
      data: (item) => item.isNotEmpty
          ? ListView.builder(
              itemCount: item.length,
              itemExtent: 90,
              itemBuilder: (context, index) => bookItem(item[index]),
            )
          : Center(
              child: Text(AppLocalizations.of(context)!.emptylibrary,
                  style: const TextStyle(fontSize: 20, color: Colors.grey))),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text(e.toString())),
    );
  }

  Widget bookItem(BookListItem bookListItem) {
    return Card(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: Color.fromRGBO(98, 163, 191, 0.5),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(2, 2),
              blurRadius: 40,
            )
          ],
        ),
        height: 70,
        child: Row(
          children: [
            SizedBox(
              width: 50,
              child: bookListItem.has_cover == 1
                  ? Image.file(File(
                      '${prefs.getString('path')}/${bookListItem.path}/cover.jpg'))
                  : Image.asset('images/cover.png'),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      bookListItem.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      bookListItem.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
