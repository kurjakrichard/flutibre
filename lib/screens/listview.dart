import 'package:flutibre/models/book.dart';
import 'package:flutter/material.dart';
import 'package:flutibre/utils/scroll.dart';
import 'package:flutibre/utils/dataservice.dart';
import 'package:flutibre/screens/details_page.dart';

class ListPage extends StatefulWidget {
  ListPage({Key? key}) : super(key: key);

  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final DataService data = DataService();
  late List<Book> _books;
  final columns = ['Author', 'Title'];
  int? sortColumnIndex;
  bool isAscending = false;
  late List<Book> selectedBooks;

  @override
  void initState() {
    super.initState();
    selectedBooks = [];
    this._books = data.getListBooks();
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
                  rows: _books.map((data) {
                    return DataRow(
                      selected: selectedBooks.contains(data),
                      onSelectChanged: (value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsPage(
                                      author: data.author,
                                      title: data.title,
                                      imagePath: data.path,
                                      index: 0,
                                    )));
                      },
                      cells: [
                        DataCell(Text(data.author)),
                        DataCell(Text(data.title)),
                      ],
                    );
                  }).toList(),
                ),
              ))),
    );
  }

  onSelectedRow(bool selected, Book book) async {
    setState(() {
      if (selected) {
        selectedBooks.add(book);
      } else {
        selectedBooks.remove(book);
      }
    });
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
            onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List<Book> _books) => _books.map((Book _book) {
        final cells = [
          _book.author,
          _book.title,
        ];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((_books) => DataCell(Text('$data'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      _books.sort((book1, book2) =>
          compareString(ascending, '${book1.author}', '${book2.author}'));
    } else if (columnIndex == 1) {
      _books.sort(
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
