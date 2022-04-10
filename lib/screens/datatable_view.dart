import 'package:flutibre/models/book.dart';
import 'package:flutibre/utils/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  int? sortColumnIndex;
  bool isAscending = false;
  late List<Book> selectedBook;
  late List<Book> books;

  @override
  void initState() {
    super.initState();
    selectedBook = [];
  }

  @override
  Widget build(BuildContext context) {
    final columns = [
      AppLocalizations.of(context)!.author,
      AppLocalizations.of(context)!.title,
    ];

    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.list,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Consumer<BookProvider>(builder: (context, value, listTile) {
              books = value.books;
              return DataTable(
                columns: getColumns(columns),
                rows: books.map((book) {
                  return DataRow(
                    selected: selectedBook.contains(book),
                    onSelectChanged: (value) {
                      Navigator.pushNamed(
                        context,
                        '/BookDetailsPage',
                        arguments: book,
                      );
                    },
                    cells: [
                      DataCell(Text(book.author_sort)),
                      DataCell(Text(book.title)),
                    ],
                  );
                }).toList(),
              );
            }),
          ),
        ),
      ),
    );
  }

  onSelectedRow(bool selected, Book book) async {
    setState(() {
      if (selected) {
        selectedBook.add(book);
      } else {
        selectedBook.remove(book);
      }
    });
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
            onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List<Book> books) => books.map((Book book) {
        final cells = [book.author_sort, book.title];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((books) => DataCell(Text('$books'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      books.sort((book1, book2) =>
          compareString(ascending, book1.author_sort, book2.author_sort));
    } else if (columnIndex == 1) {
      books.sort(
          (book1, book2) => compareString(ascending, book1.title, book2.title));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
