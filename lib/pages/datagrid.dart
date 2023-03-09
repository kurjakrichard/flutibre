import 'package:flutibre/main.dart';
import 'package:flutibre/model/booklist_item.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DataGridPage extends ConsumerStatefulWidget {
  const DataGridPage({Key? key}) : super(key: key);

  @override
  DataGridPageState createState() => DataGridPageState();
}

class DataGridPageState extends ConsumerState<DataGridPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late List<BookListItem> _bookList;
  late BookListDataSource _bookListDataSource;

  @override
  void initState() {
    super.initState();
    var provider = ref.read(booklistProvider);
    _bookList = provider.value!;
    _bookListDataSource = BookListDataSource(_bookList);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Consumer(
        builder: (context, ref, child) => SfDataGrid(
          allowSorting: true,
          allowColumnsResizing: true,
          selectionMode: SelectionMode.multiple,
          source: _bookListDataSource,
          columns: [
            GridColumn(
                columnName: 'id',
                label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerRight,
                  child: const Text(
                    'ID',
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
            GridColumn(
                columnName: 'name',
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Name',
                      overflow: TextOverflow.ellipsis,
                    ))),
            GridColumn(
                columnName: 'path',
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Path',
                      overflow: TextOverflow.ellipsis,
                    ))),
            GridColumn(
                columnName: 'sort',
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerRight,
                    child: const Text(
                      'Sort',
                      overflow: TextOverflow.ellipsis,
                    ))),
          ],
        ),
      ),
    );
  }
}

class BookListDataSource extends DataGridSource {
  BookListDataSource(List<BookListItem> bookList) {
    dataGridRows = bookList
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
              DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
              DataGridCell<String>(columnName: 'path', value: dataGridRow.path),
              DataGridCell<String>(columnName: 'sort', value: dataGridRow.sort),
            ]))
        .toList();
  }
  late List<DataGridRow> dataGridRows;
  @override
  List<DataGridRow> get rows => dataGridRows;
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          alignment: (dataGridCell.columnName == 'id' ||
                  dataGridCell.columnName == 'salary')
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }
}
