import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/book.dart';
import '../model/booklist_item.dart';
import '../providers/book_list_state.dart';
import '../providers/booklist_provider.dart';
import '../repository/database_handler.dart';

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

class BookList extends StatelessWidget {
  BookList(
    List<BookListItem>? this.bookList, {
    Key? key,
  }) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final bookList;
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
                Book selectedBook =
                    await _databaseHandler.selectedBook(bookList[index].id);
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
                    image: bookList[index].has_cover == 1
                        ? FileImage(
                            File(
                                '${bookList[index].fullPath}/${bookList[index].path}/cover.jpg'),
                          )
                        : Image.asset('images/cover.png').image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: bookList.length,
      ),
    );
  }
}
