import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class TabletHome extends StatelessWidget {
  const TabletHome(
      {super.key, required this.bookList, required this.bookDetail});
  final Widget bookList;
  final Widget bookDetail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: const Text('Tablet'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: bookList,
          ),
          Expanded(
            flex: 1,
            child: bookDetail,
          )
        ],
      ),
    );
  }
}
