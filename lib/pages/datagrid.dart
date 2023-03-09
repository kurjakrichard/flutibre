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
    _bookList = ref.watch(booklistProvider).value!;
    super.build(context);
    return SafeArea(
      child: SfDataGrid(
        allowSorting: true,
        allowColumnsResizing: false,
        columnWidthMode: ColumnWidthMode.fill,
        selectionMode: SelectionMode.single,
        source: _bookListDataSource,
        columns: [
          GridColumn(
              columnName: 'title',
              label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Title',
                  overflow: TextOverflow.ellipsis,
                ),
              )),
          GridColumn(
              columnName: 'name',
              label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Author',
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
              visible: false,
              columnName: 'sort',
              label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Sort',
                    overflow: TextOverflow.ellipsis,
                  ))),
          GridColumn(
              visible: false,
              columnName: 'author_sort',
              label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Author sort',
                    overflow: TextOverflow.ellipsis,
                  ))),
        ],
      ),
    );
  }
}

class BookListDataSource extends DataGridSource {
  BookListDataSource(List<BookListItem> bookList) {
    dataGridRows = bookList
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'title', value: dataGridRow.title),
              DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
              DataGridCell<String>(columnName: 'path', value: dataGridRow.path),
              DataGridCell<String>(columnName: 'sort', value: dataGridRow.sort),
              DataGridCell<String>(
                  columnName: 'author_sort', value: dataGridRow.author_sort),
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
          alignment:
              (dataGridCell.columnName == '' || dataGridCell.columnName == '')
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }

  @override
  int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
    final String? value1 = a
        ?.getCells()
        .firstWhere((element) => element.columnName == sortColumn.name)
        .value;
    final String? value2 = b
        ?.getCells()
        .firstWhere((element) => element.columnName == sortColumn.name)
        .value;

    int? aLength = value1?.length;
    int? bLength = value2?.length;

    if (aLength == null || bLength == null) {
      return 0;
    }

    if (aLength.compareTo(bLength) > 0) {
      return sortColumn.sortDirection == DataGridSortDirection.ascending
          ? 1
          : -1;
    } else if (aLength.compareTo(bLength) == -1) {
      return sortColumn.sortDirection == DataGridSortDirection.ascending
          ? -1
          : 1;
    } else {
      return 0;
    }
  }
}
