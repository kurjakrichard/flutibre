import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../main.dart';
import '../model/book.dart';
import '../model/booklist_item.dart';
import '../providers/book_list_state.dart';
import '../providers/booklist_provider.dart';
import '../repository/database_handler.dart';
import '../utils/constants.dart';
import 'book_details_page.dart';

class DataGrid extends ConsumerStatefulWidget {
  const DataGrid({Key? key}) : super(key: key);

  @override
  ConsumerState<DataGrid> createState() => _DataGridState();
}

class _DataGridState extends ConsumerState<DataGrid>
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
        child: TweenAnimationBuilder<double>(
          duration: const Duration(seconds: 2),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, value, child) {
            return Transform.rotate(
                angle: value * 2 * pi,
                alignment: Alignment.center,
                child: child);
          },
          child: Text(AppLocalizations.of(context)!.emptylibrary),
        ),
      );
    } else if (state is FilteredBookListLoaded) {
      return BookList(
        state.bookList,
        key: const ValueKey('Filtered'),
      );
    } else if (state is BookListLoaded) {
      return BookList(
        state.bookList,
        key: const ValueKey('Full list'),
      );
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
  late List<PlutoRow> rows;
  late BookListDataSource bookListDataSource;

  @override
  void initState() {
    bookListDataSource = BookListDataSource(widget.bookList);
    rows = bookListDataSource.dataGridRows!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var isWide = constraints.maxWidth > maxWidth;
      if (!isWide) {
        return plutoGrid(isWide);
      } else {
        return Row(
          children: [
            Expanded(child: plutoGrid(isWide)),
            const VerticalDivider(
              color: Colors.cyan,
              thickness: 3,
              width: 3,
            ),
            SizedBox(
              width: 500,
              child: selectedBook == null
                  ? Center(
                      child: Text(
                      AppLocalizations.of(context)!.nobookselected,
                      style: const TextStyle(fontSize: 25),
                    ))
                  : bookDetails,
            ),
          ],
        );
      }
    });
  }

  Widget plutoGrid(bool isWide) {
    /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
    /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
    late final PlutoGridStateManager stateManager;

    return PlutoGrid(
      mode: PlutoGridMode.selectWithOneTap,
      columns: columns,
      rows: rows,
      onLoaded: (PlutoGridOnLoadedEvent event) {
        stateManager = event.stateManager;
        stateManager.setShowColumnFilter(false);
        stateManager.notifyListeners();
      },
      onRowDoubleTap: (event) async {
        var nav = Navigator.of(context);
        int index = stateManager.currentRow!.cells.values.first.value;

        selectedBook = await _databaseHandler.selectedBook(index);
        if (!isWide) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).clearMaterialBanners();
          // ignore: use_build_context_synchronously
          nav.pushNamed(
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
      onSelected: (event) async {
        var nav = Navigator.of(context);
        int index = stateManager.currentRow!.cells.values.first.value;

        selectedBook = await _databaseHandler.selectedBook(index);
        if (!isWide) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).clearMaterialBanners();
          // ignore: use_build_context_synchronously
          nav.pushNamed(
            '/readpage',
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
      onChanged: (PlutoGridOnChangedEvent event) {
        // ignore: avoid_print
        print(event);
      },
      configuration: const PlutoGridConfiguration(
          columnSize:
              PlutoGridColumnSizeConfig(autoSizeMode: PlutoAutoSizeMode.scale)),
    );
  }

  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Id',
      field: 'id',
      hide: true,
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      frozen: PlutoColumnFrozen.start,
      title: prefs.getString('locale') == 'en' ? 'Author' : 'Szerző',
      field: 'name',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Author sort',
      field: 'author_sort',
      hide: true,
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: prefs.getString('locale') == 'en' ? 'Title' : 'Cím',
      field: 'title',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: prefs.getString('locale') == 'en' ? 'Date' : 'Dátum',
      field: 'timestamp',
      type: PlutoColumnType.date(),
    ),
  ];
}

class BookListDataSource {
  List<PlutoRow>? dataGridRows;
  BookListDataSource([List<BookListItem>? bookList]) {
    dataGridRows = plutoRows(bookList!);
  }

  List<PlutoRow> plutoRows(List<BookListItem> bookList) {
    List<PlutoRow> rows = [];
    for (var item in bookList) {
      PlutoRow row = PlutoRow(
        cells: {
          'id': PlutoCell(value: item.id),
          'name': PlutoCell(value: item.authors),
          'author_sort': PlutoCell(value: item.author_sort),
          'title': PlutoCell(value: item.title),
          'sort': PlutoCell(value: item.sort),
          'timestamp': PlutoCell(value: item.timestamp),
        },
      );

      rows.add(row);
    }
    return rows;
  }
}
