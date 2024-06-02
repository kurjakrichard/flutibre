import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../main.dart';
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
        child: Center(
          child: TweenAnimationBuilder<double>(
            duration: const Duration(seconds: 2),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, value, child) {
              return Transform.rotate(
                  angle: value * 2 * pi,
                  alignment: Alignment.center,
                  child: child);
            },
            child: Text(AppLocalizations.of(context)!.emptylibrary,
                style: const TextStyle(fontSize: 25)),
          ),
        ),
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

class BookList extends ConsumerStatefulWidget {
  const BookList(
    List<BookListItem>? this.bookList, {
    Key? key,
  }) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final bookList;

  @override
  ConsumerState<BookList> createState() => BookListState();
}

class BookListState extends ConsumerState<BookList> {
  BookDetailsPage? bookDetails;
  Book? selectedBook;
  final DatabaseHandler _databaseHandler = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var isWide = constraints.maxWidth > maxWidth;
      if (!isWide) {
        return listView(widget.bookList, isWide, ref);
      } else {
        return Row(
          children: [
            Expanded(child: listView(widget.bookList, isWide, ref)),
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

  Widget listView(List<BookListItem> item, bool isWide, WidgetRef ref) {
    return ListView.builder(
      itemCount: item.length,
      itemExtent: 110,
      itemBuilder: (context, index) => InkWell(
          highlightColor: const Color.fromARGB(255, 47, 119, 177),
          splashColor: Colors.green,
          onTap: () async {
             ref.read(selectedEbookProvider.notifier).state = item[index];
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
          child: bookItem(item[index], ref)),
    );
  }

  Widget bookItem(BookListItem bookListItem, ref) {
    return Card(
      elevation: 5,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration:  BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color:  bookListItem == ref.watch(selectedEbookProvider) ? const Color.fromRGBO(98, 163, 191, 0.7) : const Color.fromRGBO(98, 163, 191, 0.3),
          boxShadow: [
            const BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(2, 2),
              blurRadius: 40,
            )
          ],
        ),
        height: 110,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 80,
              child: bookListItem.has_cover == 1
                  ? Image.file(
                      File(
                          '${prefs.getString('path')}/${bookListItem.path}/cover.jpg'),
                      fit: BoxFit.fitHeight)
                  : Image.asset(
                      'images/cover.png',
                      fit: BoxFit.fitHeight,
                    ),
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
                      bookListItem.authors,
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
