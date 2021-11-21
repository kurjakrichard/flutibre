import 'package:flutter/material.dart';
import 'package:flutibre/utils/scroll.dart';
import 'package:flutibre/models/girl.dart';
import 'package:flutibre/utils/dataservice.dart';
import 'package:flutibre/screens/details_page.dart';

class ListPage extends StatefulWidget {
  ListPage({Key? key}) : super(key: key);

  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final DataService data = DataService();
  late List<ImageDetails> _images;
  final columns = ['Price', 'Title', 'Photographer'];
  int? sortColumnIndex;
  bool isAscending = false;
  late List<ImageDetails> selectedImages;

  @override
  void initState() {
    super.initState();
    selectedImages = [];
    this._images = data.getListGirls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List"),
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
                  rows: _images.map((data) {
                    return DataRow(
                      selected: selectedImages.contains(data),
                      onSelectChanged: (value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsPage(
                                      imagePath: data.imagePath,
                                      title: data.title,
                                      photographer: data.photographer,
                                      price: data.price,
                                      details: data.details,
                                      index: 0,
                                    )));
                      },
                      cells: [
                        DataCell(Text(data.price)),
                        DataCell(Text(data.title)),
                        DataCell(Text(data.photographer))
                      ],
                    );
                  }).toList(),
                ),
              ))),
    );
  }

  onSelectedRow(bool selected, ImageDetails image) async {
    setState(() {
      if (selected) {
        selectedImages.add(image);
      } else {
        selectedImages.remove(image);
      }
    });
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
            onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List<ImageDetails> _images) =>
      _images.map((ImageDetails _image) {
        final cells = [_image.price, _image.title, _image.photographer];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((_images) => DataCell(Text('$data'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      _images.sort((image1, image2) =>
          compareString(ascending, '${image1.price}', '${image2.price}'));
    } else if (columnIndex == 1) {
      _images.sort((image1, image2) =>
          compareString(ascending, image1.title, image2.title));
    } else if (columnIndex == 2) {
      _images.sort((image1, image2) =>
          compareString(ascending, image1.photographer, image2.photographer));
    }

    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
