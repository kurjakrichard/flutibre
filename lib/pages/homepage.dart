// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../main.dart';
import '../model/book.dart';
import '../model/booklist_item.dart';
import '../model/data.dart';
import '../providers/booklist_provider.dart';
import '../utils/ebook_service.dart';

enum Page { list, grid, datatable }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  final Book _book = Book();
  final EbookService _bookService = EbookService();
  List<BookListItem>? _dataTableBookList;
  late List<Book> _selectedBooks;
  int _selectedIndex = 0;
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
    bookDetails = bookDetailsItem();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Consumer<BookListProvider>(
          builder: (context, books, child) => Scaffold(
            drawer: drawerNavigation(context),
            floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  _showFormDialog(context);
                }),
            appBar: AppBar(
              title: const Text(
                'Flutibre',
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showMaterialBanner(
                      MaterialBanner(
                        content: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            value.isEmpty
                                ? books.toggleAllBooks()
                                : books.filteredBookList(value);
                          },
                          textInputAction: TextInputAction.go,
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.search,
                            ),
                            border: InputBorder.none,
                            hintText: 'Search term',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .clearMaterialBanners();
                            },
                            child: const Text('Bezárás'),
                          )
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
            bottomNavigationBar: bottomNavigationBar(),
            body: IndexedStack(
              index: currentPage.index,
              children: [
                LayoutBuilder(builder: (context, constraints) {
                  var isWideLayout = constraints.maxWidth > 850;
                  if (!isWideLayout) {
                    return listView(false, books);
                  } else {
                    return Row(
                      children: [
                        Expanded(child: listView(true, books)),
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
                gridView(books),
                //dataTable(books),
              ],
            ),
          ),
        ));
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
          currentPage = Page.values[index];
        });
      },
      items: [
        BottomNavigationBarItem(
          label: '',
          icon: Tooltip(
              message: AppLocalizations.of(context)!.list,
              child: const Icon(Icons.list)),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: Tooltip(
              message: AppLocalizations.of(context)!.tiles,
              child: const Icon(Icons.grid_4x4)),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: Tooltip(
              message: AppLocalizations.of(context)!.datatable,
              child: const Icon(Icons.dataset)),
        ),
      ],
    );
  }

//DrawerNavigation widget
  Widget drawerNavigation(context) {
    return Material(
      child: Drawer(
        child: ListView(children: [
          DrawerHeader(
              child: Row(
            children: [
              Image.asset('images/bookshelf-icon2.png'),
              const Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text(
                  'Flutibre',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          )),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(AppLocalizations.of(context)!.homepage),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/homepage',
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.settingspage),
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          )
        ]),
      ),
    );
  }

  //ListView tab
  FutureBuilder listView(bool isWide, BookListProvider books) {
    Book? selectedBook;
    return FutureBuilder(
        future: books.currentBooks,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length as int,
              itemExtent: 90,
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onTap: () async {
                    List<Data>? formats = await _bookService
                        .readBookFormats(snapshot.data[index].id);
                    selectedBook = Book(
                        id: snapshot.data[index].id,
                        title: snapshot.data[index].title,
                        author_sort: snapshot.data[index].author_sort,
                        path: snapshot.data[index].path,
                        has_cover: snapshot.data[index].has_cover,
                        series_index: snapshot.data[index].series_index,
                        formats: formats);
                    if (!isWide) {
                      Navigator.pushNamed(
                        context,
                        '/bookdetailspage',
                        arguments: selectedBook,
                      );
                    } else {
                      setState(() {
                        bookDetails = bookDetailsItem(book: selectedBook);
                      });
                    }
                  },
                  child: bookItem(snapshot.data[index]),
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
              child: loadCover(book.has_cover, book.path),
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
                      book.name ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      book.title ?? '',
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
  FutureBuilder gridView(BookListProvider books) {
    int size = MediaQuery.of(context).size.width.round();
    return FutureBuilder(
        future: books.currentBooks,
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
                    onPressed: () async {
                      List<Data>? formats = await _bookService
                          .readBookFormats(snapshot.data[index].id);
                      Book selectedBook = Book(
                          id: snapshot.data[index].id,
                          title: snapshot.data[index].title,
                          author_sort: snapshot.data[index].author_sort,
                          path: snapshot.data[index].path,
                          has_cover: snapshot.data[index].has_cover,
                          series_index: snapshot.data[index].series_index,
                          formats: formats);
                      Navigator.pushNamed(
                        context,
                        '/bookdetailspage',
                        arguments: selectedBook,
                      );
                    },
                    child: Hero(
                      tag: 'logo$index',
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: snapshot.data[index].has_cover == 1
                                ? FileImage(
                                    File(prefs.getString('path')! +
                                        '/' +
                                        snapshot.data[index].path +
                                        '/cover.jpg'),
                                  )
                                : Image.asset('images/cover.png').image,
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
  Widget dataTable(BookListProvider books) {
    _selectedBooks = [];
    return FutureBuilder(
        future: books.currentBooks,
        builder:
            (BuildContext context, AsyncSnapshot<List<BookListItem>> snapshot) {
          if (snapshot.hasData) {
            _dataTableBookList = snapshot.data;
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
                      // ignore: iterable_contains_unrelated_type
                      selected: _selectedBooks.contains(book),
                      onSelectChanged: (value) async {
                        List<Data>? formats =
                            await _bookService.readBookFormats(book.id);
                        Book selectedBook = Book(
                            id: book.id,
                            title: book.title,
                            author_sort: book.author_sort,
                            path: book.path,
                            has_cover: book.has_cover,
                            series_index: book.series_index,
                            formats: formats);
                        Navigator.pushNamed(
                          context,
                          '/bookdetailspage',
                          arguments: selectedBook,
                        );
                      },
                      cells: [
                        DataCell(Text(book.author_sort,
                            style: Theme.of(context).textTheme.bodyMedium)),
                        DataCell(Text(book.title,
                            style: Theme.of(context).textTheme.bodyMedium)),
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
      _dataTableBookList!.sort((book1, book2) =>
          compareString(ascending, book1.author_sort, book2.author_sort));
    } else if (columnIndex == 1) {
      _dataTableBookList!.sort(
          (book1, book2) => compareString(ascending, book1.title, book2.title));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

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

  Widget bookDetailsItem({Book? book}) {
    List<String> formats = [];
    if (book == null) {
      return const Center(child: Text('Nincs könyv kiválasztva'));
    } else {
      for (var item in book.formats!) {
        formats.add(item.format.toLowerCase());
      }
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: loadCover(book.has_cover, book.path),
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
                          ),
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
                              ),
                              child: const Text(
                                'Back',
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                String bookPath =
                                    '${prefs.getString('path')}/${book.path}/${book.formats![0].name}.${book.formats![0].format.toLowerCase()}';
                                OpenFilex.open(bookPath);
                              },
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                              child: const Text(
                                'Open',
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 60)
            ],
          ));
    }
  }

  Image loadCover(int hasCover, String path) {
    return hasCover == 1
        ? Image.file(File('${prefs.getString('path')}/$path/cover.jpg'))
        : Image.asset('images/cover.png');
  }

  Widget bookDetailElement(
      {required String detailType, required String detailContent}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(detailType, overflow: TextOverflow.ellipsis),
        const VerticalDivider(),
        Flexible(
          child: Text(detailContent, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
