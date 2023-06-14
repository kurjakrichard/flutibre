import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/book.dart';
import '../model/booklist_item.dart';
import '../providers/book_list_state.dart';
import '../providers/booklist_provider.dart';
import '../repository/database_handler.dart';
import '../utils/constants.dart';
import 'book_details_page.dart';

class ListPage extends ConsumerStatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ListPage> createState() => _ListPageState();
}

class _ListPageState extends ConsumerState<ListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = ref.watch(bookListProvider);
    if (state is BookListInitial) {
      return const SizedBox();
    } else if (state is BookListLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is BookListEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.emptylibrary),
      );
    } else if (state is FilteredBookListLoaded) {
      return BookList(state.bookList);
    } else if (state is BookListLoaded) {
      return BookList(state.bookList);
    } else {
      return Text(AppLocalizations.of(context)!.error);
    }
  }
}

class BookList extends StatefulWidget {
  const BookList(
    List<BookListItem>? this.bookList, {
    Key? key,
  }) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final bookList;

  @override
  State<BookList> createState() => BookListState();
}

class BookListState extends State<BookList> {
  BookDetailsPage? bookDetails;
  Book? selectedBook;
  final DatabaseHandler _databaseHandler = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var isWide = constraints.maxWidth > maxWidth;
      if (!isWide) {
        return listView(widget.bookList, isWide);
      } else {
        return Row(
          children: [
            Expanded(child: listView(widget.bookList, isWide)),
            const VerticalDivider(
              color: Colors.cyan,
              thickness: 3,
              width: 3,
            ),
            SizedBox(
              width: 500,
              child: selectedBook == null
                  ? Center(
                      child: Text(AppLocalizations.of(context)!.nobookselected))
                  : bookDetails,
            ),
          ],
        );
      }
    });
  }

  Widget listView(List<BookListItem> item, bool isWide) {
    return ListView.builder(
      itemCount: item.length,
      itemExtent: 90,
      itemBuilder: (context, index) => GestureDetector(
          onTap: () async {
            selectedBook = await _databaseHandler.selectedBook(item[index].id);
            if (!isWide) {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).clearMaterialBanners();
              // ignore: use_build_context_synchronously
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
