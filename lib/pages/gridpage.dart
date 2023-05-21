import 'dart:io';
import 'package:flutibre/providers/booklist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/book.dart';
import '../model/booklist_item.dart';
import '../providers/book_list_state.dart';
import '../repository/database_handler.dart';
import 'book_details_page.dart';

class GridPage extends ConsumerStatefulWidget {
  const GridPage({Key? key}) : super(key: key);

  @override
  ConsumerState<GridPage> createState() => _GridPageState();
}

class _GridPageState extends ConsumerState<GridPage>
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
      return const Center(
        child: Text('No books'),
      );
    } else if (state is FilteredBookListLoaded) {
      return BookList(state.bookList);
    } else if (state is BookListLoaded) {
      return BookList(state.bookList);
    } else {
      return const Text('Error');
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
    int size = MediaQuery.of(context).size.width.round();
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (size / 150).round(),
          crossAxisSpacing: 10,
          childAspectRatio: 2 / 3,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return Center(
            child: RawMaterialButton(
              onPressed: () async {
                selectedBook = await _databaseHandler
                    .selectedBook(widget.bookList[index].id);
                // ignore: use_build_context_synchronously
                Navigator.pushNamed(
                  context,
                  '/bookdetailspage',
                  arguments: selectedBook,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: widget.bookList[index].has_cover == 1
                        ? FileImage(
                            File(
                                '${widget.bookList[index].fullPath}/${widget.bookList[index].path}/cover.jpg'),
                          )
                        : Image.asset('images/cover.png').image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: widget.bookList.length,
      ),
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
