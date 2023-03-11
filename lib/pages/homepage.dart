import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutibre/pages/gridpage.dart';
import 'package:flutibre/pages/listpage.dart';
import '../main.dart';
import 'datagrid.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final PageController controller = PageController();

  @override
  bool get wantKeepAlive => true;
  TextEditingController searchController = TextEditingController();
  int currentIndex = 0;
  final tabPages = [const ListPage(), const GridPage(), const DataGridPage()];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer(
      builder: (context, ref, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Flutibre"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                ScaffoldMessenger.of(context).showMaterialBanner(
                  MaterialBanner(
                    content: TextField(
                      controller: searchController,
                      onChanged: (value) async {
                        value.isEmpty
                            ? await ref.read(bookListProvider).toggleAllBooks()
                            : await ref
                                .read(bookListProvider)
                                .filteredBookList(value);

                        await ref.read(booklistProvider.future);
                      },
                      textInputAction: TextInputAction.go,
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.search,
                        ),
                        border: InputBorder.none,
                        hintText: 'Search term',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).clearMaterialBanners();
                        },
                        child: const Text('Bezárás'),
                      )
                    ],
                  ),
                );
              },
            )
          ],
        ),
        drawer: drawerNavigation(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Consumer(
          builder: (_, ref, child) {
            return FloatingActionButton(
              onPressed: () async {
                // ignore: todo
                //TODO
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
      ),
    );
  }

  //DrawerNavigation widget
  Widget drawerNavigation(context) {
    return Material(
      child: Drawer(
        child: ListView(children: [
          DrawerHeader(
              child: Row(
            children: [
              Image.asset('images/bookshelf-icon2.png'),
              const Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text(
                  'Flutibre',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          )),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(AppLocalizations.of(context)!.homepage),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/homepage',
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.settingspage),
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          )
        ]),
      ),
    );
  }
}
