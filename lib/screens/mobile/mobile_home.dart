import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/config.dart';
import '../../widgets/widgets.dart';

class MobileHome extends StatelessWidget {
  const MobileHome({super.key, required this.bookList});
  final Widget bookList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mobile'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push(RouteLocation.insertBook),
          child: const Icon(Icons.add),
        ),
        drawer: const SideMenu(),
        body: SafeArea(child: bookList));
  }
}
