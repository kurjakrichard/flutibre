import 'package:flutter/material.dart';
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
        drawer: const SideMenu(),
        body: bookList);
  }
}
