import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/config.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteLocation.insertBook),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Tablet'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: bookList,
          ),
          const VerticalDivider(
            thickness: 4,
            color: Colors.purple,
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
