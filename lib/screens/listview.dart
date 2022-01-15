import 'package:flutibre/models/book_data.dart';
import 'package:flutter/material.dart';
import 'package:flutibre/utils/scroll.dart';
import 'package:flutibre/screens/details_page.dart';

class ListPage extends StatefulWidget {
  ListPage({Key? key, required this.books}) : super(key: key);

  final List<BookData> books;

  @override
  _ListPageState createState() => _ListPageState(books: books);
}

class _ListPageState extends State<ListPage> {
  _ListPageState({required this.books});
  List<BookData> books;

  final columns = ['Author', 'Title', 'Language'];
  int? sortColumnIndex;
  bool isAscending = false;
  late List<BookData> selectedBook;

  @override
  void initState() {
    super.initState();
    selectedBook = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        title: Text(
          "List",
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: MaterialApp(
          debugShowCheckedModeBanner: false,
          scrollBehavior: MyCustomScrollBehavior(),
          // Create a grid with columns fit to screen. If you change the scrollDirection to
          // horizontal, this produces rows.

          home: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: getColumns(columns),
                  rows: books.map((data) {
                    return DataRow(
                      selected: selectedBook.contains(data),
                      onSelectChanged: (value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BookDetailsPage(),
                              settings: RouteSettings(arguments: data),
                            ));
                      },
                      cells: [
                        DataCell(Text(data.author)),
                        DataCell(Text(data.title)),
                        DataCell(Text(data.language)),
                      ],
                    );
                  }).toList(),
                ),
              ))),
    );
  }

  onSelectedRow(bool selected, BookData book) async {
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

  List<DataRow> getRows(List<BookData> books) => books.map((BookData book) {
        final cells = [
          book.author,
          book.title,
        ];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((books) => DataCell(Text('$books'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      books.sort((book1, book2) =>
          compareString(ascending, '${book1.author}', '${book2.author}'));
    } else if (columnIndex == 1) {
      books.sort(
          (book1, book2) => compareString(ascending, book1.title, book2.title));
    }

    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
