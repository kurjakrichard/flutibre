import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/book.dart';
import '../utils/ebook_service.dart';

enum Page { list, grid, datatable }

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
  late List<Book> _selectedBook;
  String? _path;
  int? sortColumnIndex;
  bool isAscending = false;
  Page currentPage = Page.list;
  Widget? bookDetails;
  String formats = "";
  final _columns = [
    'author',
    'title',
  ];

  @override
  void initState() {
    super.initState();
    getPath();
    bookDetails = bookDetailsItem();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        drawer: DrawerNavigation(context),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              _showFormDialog(context);
            }),
        appBar: AppBar(
          title: Text(
            'Flutibre',
            style: Theme.of(context).textTheme.headline1,
          ),
          bottom: TabBar(
            //Azért nem kell index, mert maga a widget azonosítja a tabot.
            labelColor: Colors.white,
            indicatorColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            tabs: <Widget>[
              Tab(
                icon: Tooltip(child: Icon(Icons.list), message: 'Lista'),
              ),
              Tab(
                icon: Tooltip(child: Icon(Icons.grid_4x4), message: 'Rács'),
              ),
              Tab(
                icon: Tooltip(child: Icon(Icons.dataset), message: 'Adattábla'),
              ),
            ],
            onTap: (index) {
              setState(() {
                currentPage = Page.values[index];
              });
            },
          ),
        ),
        body: IndexedStack(
          children: [
            LayoutBuilder(builder: (context, constraints) {
              var isWideLayout = constraints.maxWidth > 850;
              if (!isWideLayout) {
                return listView(false);
              } else {
                return Row(
                  children: [
                    Expanded(child: listView(true)),
                    const VerticalDivider(
                      color: Colors.cyan,
                      thickness: 3,
                      width: 3,
                    ),
                    SizedBox(
                      width: 450,
                      child: bookDetails,
                    ),
                  ],
                );
              }
            }),
            gridView(),
            dataTable(),
          ],
          index: currentPage.index,
        ),
      ),
    );
  }

  //DrawerNavigation widget
  Widget DrawerNavigation(context) {
    return Drawer(
      child: Material(
        color: Color.fromRGBO(98, 163, 191, 0.9),
        child: ListView(children: [
          DrawerHeader(
              decoration: const BoxDecoration(color: Colors.cyan),
              child: Container(
                  // color: Color.fromRGBO(119, 179, 212, 1),
                  child: Image.asset('images/bookshelf-icon.png'))),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(
              AppLocalizations.of(context)!.mainwindow,
              style: Theme.of(context).textTheme.headline3,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MainWindow()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              AppLocalizations.of(context)!.settingspage,
              style: Theme.of(context).textTheme.headline3,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/SettingsPage',
              );
            },
          )
        ]),
      ),
    );
  }

  //ListView tab
  FutureBuilder listView(bool isWide) {
    return FutureBuilder(
        future: _bookService.readBooks('title'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length as int,
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onTap: () {
                    if (!isWide) {
                      snapshot.data[index].path.toString().contains('cover.jpg')
                          ? snapshot.data[index].path
                          : snapshot.data[index].path = coverPath(_path! +
                              '/' +
                              snapshot.data[index].path +
                              '/cover.jpg');
                      Navigator.pushNamed(
                        context,
                        '/BookDetailsPage',
                        arguments: snapshot.data[index],
                      );
                    } else {
                      setState(() {
                        bookDetails =
                            bookDetailsItem(book: snapshot.data[index]);
                      });
                    }
                  },
                  child: bookItem(
                    snapshot.data[index],
                  ),
                );
              }),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget bookItem(book) {
    return Card(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
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
              child: Image.file(
                File(coverPath(_path! + '/' + book.path + '/cover.jpg')),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      book.author_sort ?? '',
                      style: Theme.of(context).textTheme.subtitle1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      book.title ?? '',
                      style: Theme.of(context).textTheme.subtitle2,
                      overflow: TextOverflow.ellipsis,
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

  //GridView tab
  FutureBuilder gridView() {
    int size = MediaQuery.of(context).size.width.round();
    return FutureBuilder(
        future: _bookService.readBooks('title'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (size / 200).round(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return Center(
                  child: RawMaterialButton(
                    onPressed: () {
                      snapshot.data[index].path.toString().contains('cover.jpg')
                          ? snapshot.data[index].path
                          : snapshot.data[index].path = coverPath(_path! +
                              '/' +
                              snapshot.data[index].path +
                              '/cover.jpg');
                      Navigator.pushNamed(
                        context,
                        '/BookDetailsPage',
                        arguments: snapshot.data[index],
                      );
                    },
                    child: Hero(
                      tag: 'logo$index',
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: FileImage(
                              File(coverPath(_path! +
                                  '/' +
                                  snapshot.data[index].path +
                                  '/cover.jpg')),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: snapshot.data.length,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  //DataTable tab
  Widget dataTable() {
    _selectedBook = [];
    return FutureBuilder(
        future: _bookService.readBooks('title'),
        builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
          if (snapshot.hasData) {
            _bookList = snapshot.data;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  showCheckboxColumn: false,
                  dataRowHeight: 40,
                  columns: getColumns(_columns),
                  rows: snapshot.data!.map((book) {
                    return DataRow(
                      selected: _selectedBook.contains(book),
                      onSelectChanged: (value) async {
                        book.path.contains('cover.jpg')
                            ? book.path
                            : book.path = coverPath(
                                _path! + '/' + book.path + '/cover.jpg');
                        Navigator.pushNamed(
                          context,
                          '/BookDetailsPage',
                          arguments: book,
                        );
                      },
                      cells: [
                        DataCell(Text(book.author_sort,
                            style: Theme.of(context).textTheme.bodyText2)),
                        DataCell(Text(book.title,
                            style: Theme.of(context).textTheme.bodyText2)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
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

  String coverPath(String path) {
    return File(path).existsSync() ? path : 'images/cover.png';
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
                  int result = await _bookService.insertBook(_book);
                  setState(() {
                    _bookService.readBooks('title');
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
            title: const Text('Add book'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                        hintText: 'Write a Title', labelText: 'Title'),
                  ),
                  TextField(
                    controller: _authorController,
                    decoration: const InputDecoration(
                        hintText: 'Write a author', labelText: 'Author'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  //Database path
  void getPath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _path = await prefs.getString('path');

    setState(() {
      _path;
    });
  }

  Widget bookDetailsItem({Book? book}) {
    List<String> formats = [];
    if (book == null) {
      return Center(child: Text('Nincs könyv kiválasztva'));
    } else {
      for (var item in book.formats!) {
        formats.add(item.format.toLowerCase());
      }
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Image.file(
                  File(coverPath(_path! + '/' + book.path + '/cover.jpg')),
                ),
              ),
              SizedBox(
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          bookDetailElement(
                              detailType: 'Title:', detailContent: book.title),
                          bookDetailElement(
                              detailType: 'Author:',
                              detailContent: book.author_sort),
                          Text(
                              'Formats: ${formats.toString().replaceAll('[', '').replaceAll(']', '')}',
                              style: Theme.of(context).textTheme.bodyText1),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                backgroundColor: Colors.cyan,
                              ),
                              child: Text(
                                'Back',
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                print(book.path);
                                String bookPath = await _path! +
                                    '/' +
                                    book.path +
                                    '/' +
                                    book.formats![0].name +
                                    '.' +
                                    book.formats![0].format.toLowerCase();
                                if (Platform.isWindows) {
                                  OpenFilex.open(
                                      bookPath.replaceAll('/', '\\'));
                                } else {
                                  OpenFilex.open(bookPath);
                                }
                              },
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                backgroundColor: Colors.cyan,
                              ),
                              child: Text(
                                'Open',
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 60)
            ],
          ));
    }
  }

  Widget bookDetailElement(
      {required String detailType, required String detailContent}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(detailType,
            style: Theme.of(context).textTheme.headline2,
            overflow: TextOverflow.ellipsis),
        const VerticalDivider(),
        Flexible(
          child: Text(detailContent,
              style: Theme.of(context).textTheme.bodyText1,
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
