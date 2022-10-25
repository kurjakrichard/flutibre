import 'dart:io';
import 'package:flutibre/screens/settingspage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';
import '../utils/ebook_service.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({Key? key}) : super(key: key);

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _authorController = TextEditingController();

  Book _book = Book();
  EbookService _bookService = EbookService();
  List<Book>? _bookList;
  late List<Book> selectedBook;
  String? path;
  int? sortColumnIndex;
  bool isAscending = false;
  final columns = [
    'author',
    'title',
  ];

  @override
  void initState() {
    super.initState();
    getBooks();
    getPath();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        drawer: DrawerNavigation(context),
        floatingActionButton:
            FloatingActionButton(child: Icon(Icons.add), onPressed: () {}),
        appBar: AppBar(
          bottom: const TabBar(
            //Azért nem kell index, mert maga a widget azonosítja a tabot.
            labelColor: Colors.white,
            indicatorColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.list),
                text: "Lista",
              ),
              Tab(
                icon: Icon(Icons.grid_4x4),
                text: "Rács",
              ),
              Tab(
                icon: Icon(Icons.dataset),
                text: "Adattábla",
              ),
            ],
          ),
          title: Text('Flutibre'),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(child: listView()),
            Center(
              child: Text("Második fül"),
            ),
            Container(child: dataTable()),
          ],
        ),
      ),
    );
  }

  //ListView tab
  Widget listView() {
    return ListView.builder(
        itemCount: _bookList?.length,
        itemBuilder: ((context, index) {
          return bookItem(index);
        }));
  }

  //DataTable tab
  Widget dataTable() {
    selectedBook = [];
    return DataTable(
      showCheckboxColumn: false,
      columns: getColumns(columns),
      rows: _bookList!.map((book) {
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
  }

  Widget bookItem(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, left: 8.0),
      child: Card(
        elevation: 8.0,
        child: ListTile(
          tileColor: const Color.fromRGBO(98, 163, 191, 0.5),
          leading: _bookList?.length != null
              ? Image.file(
                  File(_bookList?[index].path != null
                      ? coverPath(
                          path! + '/' + _bookList![index].path + '/cover.jpg')!
                      : 'images/cover.jpg'),
                )
              : Image.file(File('images/cover.jpg')),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _bookList?.length != null ? _bookList![index].author_sort : '',
                overflow: TextOverflow.ellipsis,
              ),
              IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () {})
            ],
          ),
          subtitle: Text(
            _bookList?.length != null ? _bookList![index].title : '',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget DrawerNavigation(context) {
    return Drawer(
      child: ListView(children: [
        DrawerHeader(
            //decoration: BoxDecoration(color: Colors.blue),
            child: Image.asset('images/bookshelf-icon.png')),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Main window'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => MainWindow()));
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings page'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SettingsPage()));
          },
        )
      ]),
    );
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
      _bookList!.sort((book1, book2) =>
          compareString(ascending, book1.author_sort, book2.author_sort));
    } else if (columnIndex == 1) {
      _bookList!.sort(
          (book1, book2) => compareString(ascending, book1.title, book2.title));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  void getBooks() async {
    _bookList = await _bookService.readBooks('books', 'title');

    setState(() {
      _bookList;
    });
  }

  String? coverPath(String path) {
    return File(path).existsSync() ? path : 'images/cover.jpg';
  }

  // ignore: unused_element
  Future _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (value) {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () async {
                  _book.title = _titleController.text;
                  _book.author_sort = _authorController.text;
                  // ignore: unused_local_variable
                  int result = await _bookService.insertBook('books', _book);
                  setState(() {
                    getBooks();
                  });
                  _titleController = TextEditingController();
                  _authorController = TextEditingController();

                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (state) => Colors.blue)),
                child:
                    const Text('Save', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (state) => Colors.red)),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            title: const Text('Categories Form'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                        hintText: 'Write a category', labelText: 'Category'),
                  ),
                  TextField(
                    controller: _authorController,
                    decoration: const InputDecoration(
                        hintText: 'Write a description',
                        labelText: 'Description'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void getPath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    path = await prefs.getString('path');

    setState(() {
      path;
    });
  }
}
