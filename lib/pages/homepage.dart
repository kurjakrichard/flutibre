import 'package:flutibre/pages/gridpage.dart';
import 'package:flutibre/pages/listpage.dart';
import 'package:flutter/material.dart';
import 'package:flutibre/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final PageController controller = PageController();

  /// initializing controller for PageView

  int currentIndex = 0;
  final tabPages = [const ListPage(), const GridPage()];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Flutibre")),
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          return FloatingActionButton(
            onPressed: () async {
              await ref.read(bookListProvider).toggleAllBooks();
              // ignore: unused_result
              ref.refresh(booklistProvider);
            },
            child: const Icon(Icons.add),
          );
        },
      ),
      body: PageView(
        /// Wrapping the tabs with PageView
        controller: controller,
        children: tabPages,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;

            /// Switching bottom tabs
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          controller.jumpToPage(index);

          /// Switching the PageView tabs
          setState(() {
            currentIndex = index;
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
