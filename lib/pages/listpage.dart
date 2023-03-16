// ignore_for_file: use_build_context_synchronously

import 'package:flutibre/pages/book_details_page.dart';
import 'package:flutibre/repository/database_handler.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../main.dart';
import '../model/book.dart';
import '../model/booklist_item.dart';

class ListPage extends ConsumerStatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ListPage> createState() => _ListPageState();
}

class _ListPageState extends ConsumerState<ListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final DatabaseHandler _databaseHandler = DatabaseHandler();
  Book? selectedBook;
  BookDetailsPage? bookDetails;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    AsyncValue<List<BookListItem>> itemValue = ref.watch(booklistProvider);
    return itemValue.when(
      data: (item) => item.isNotEmpty
          ? LayoutBuilder(builder: (context, constraints) {
              var isWide = constraints.maxWidth > 900;
              if (!isWide) {
                return listView(item, isWide);
              } else {
                return Row(
                  children: [
                    Expanded(child: listView(item, isWide)),
                    const VerticalDivider(
                      color: Colors.cyan,
                      thickness: 3,
                      width: 3,
                    ),
                    SizedBox(
                      width: 450,
                      child: selectedBook == null
                          ? Center(
                              child: Text(
                                  AppLocalizations.of(context)!.nobookselected))
                          : bookDetails,
                    ),
                  ],
                );
              }
            })
          : Center(
              child: Text(AppLocalizations.of(context)!.emptylibrary,
                  style: const TextStyle(fontSize: 20, color: Colors.grey))),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text(e.toString())),
    );
  }

  Widget listView(List<BookListItem> item, bool isWide) {
    return ListView.builder(
      itemCount: item.length,
      itemExtent: 90,
      itemBuilder: (context, index) => GestureDetector(
          onTap: () async {
            selectedBook = await _databaseHandler.selectedBook(item[index].id);
            if (!isWide) {
              Navigator.pushNamed(
                context,
                '/bookdetailspage',
                arguments: selectedBook,
              );
            } else {
              setState(() {
                bookDetails = BookDetailsPage(
                  book: selectedBook,
                );
              });
            }
          },
          child: bookItem(item[index])),
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
                      '${bookListItem.fullPath}/${bookListItem.path}/cover.jpg'))
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
