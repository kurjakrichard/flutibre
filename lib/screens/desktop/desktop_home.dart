import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class DesktopHome extends StatelessWidget {
  const DesktopHome(
      {super.key, required this.bookList, required this.bookDetail});
  final Widget bookList;
  final Widget bookDetail;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desktop'),
      ),
      drawer: null,
      body: Row(
        children: [
          const Expanded(
            flex: 1,
            child: SideMenu(),
          ),
          Expanded(
            flex: 5,
            child: bookList,
          ),
          Expanded(
            flex: 2,
            child: bookDetail,
          )
        ],
      ),
    );
  }
}
