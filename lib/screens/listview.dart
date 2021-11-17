import 'package:flutter/material.dart';
import 'package:flutibre/utils/scroll.dart';
import 'package:flutibre/models/girl.dart';
import 'package:flutibre/utils/dataservice.dart';
import 'package:flutibre/screens/details_page.dart';

class ListPage extends StatelessWidget {
  ListPage({Key? key}) : super(key: key);
  final DataService data = DataService();

  List<ImageDetails> get _images => data.getListGirls();

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

                  columns: const [
                    DataColumn(label: Text("Price")),
                    DataColumn(label: Text("Title")),
                    DataColumn(label: Text("Photographer")),
                    DataColumn(label: FlutterLogo()),
                  ],
                  rows: _images.map((data) {
                    return DataRow(
                      selected: sel,
                      onSelectChanged: (value) { Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsPage(
                      imagePath: _images[index].imagePath,
                      title: _images[index].title,
                      photographer: _images[index].photographer,
                      price: _images[index].price,
                      details: _images[index].details,
                      index: index,
                    ),
                      },
                      cells: [
                        DataCell(Text(data.price)),
                        DataCell(Text(data.title)),
                        DataCell(Text(data.photographer)),
                        DataCell(FlutterLogo())
                      ],
                    );
                  }).toList(),
                ),
              ))),
    );
  }
}
