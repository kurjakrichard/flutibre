import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/booklist_provider.dart';
import 'datagrid.dart';
import 'gridpage.dart';
import 'listpage.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with AutomaticKeepAliveClientMixin {
  final PageController controller = PageController();

  @override
  bool get wantKeepAlive => true;
  bool isShowBanner = false;
  TextEditingController searchController = TextEditingController();
  int currentIndex = 0;
  bool isSearching = false;
  GlobalKey globalKey = GlobalKey();
  final List<Widget> tabPages = [
    const ListPage(),
    const GridPage(),
    const DataGrid(),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: appBar(context),
      drawer: !isSearching ? drawerNavigation(context) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          ScaffoldMessenger.of(context).clearMaterialBanners();
          Navigator.pushNamed(context, '/addpage');
        },
        child: const Icon(Icons.add),
      ),
      body: PageView(
        /// Wrapping the tabs with PageView
        controller: controller,
        children: tabPages,
        onPageChanged: (index) {
          WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
                currentIndex = index;
              }));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          /// Switching the PageView tabs
          controller.jumpToPage(index);
          WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
                currentIndex = index;
              }));
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
                message: AppLocalizations.of(context)!.datagrid,
                child: const Icon(Icons.dataset)),
          )
        ],
      ),
    );
  }

  Widget showBanner(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            key: globalKey,
            controller: searchController,
            onSubmitted: (value) async {
              ref.read(bookListProvider.notifier).filteredBookItemList(value);
            },
            textInputAction: TextInputAction.go,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: AppLocalizations.of(context)!.search,
            ),
          ),
        ),
      ],
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
              ScaffoldMessenger.of(context).clearMaterialBanners();
              isShowBanner = !isShowBanner;
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          )
        ]),
      ),
    );
  }

  PreferredSizeWidget? appBar2(BuildContext context) {
    return AppBar(
      title: const Text("Flutibre"),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            !isShowBanner
                ? ScaffoldMessenger.of(context).showMaterialBanner(
                    MaterialBanner(
                      content: showBanner(context),
                      actions: [
                        IconButton(
                            tooltip: 'Reset',
                            onPressed: () async {
                              searchController.clear();
                              ref
                                  .read(bookListProvider.notifier)
                                  .loadBookItemList();
                            },
                            icon: const Icon(Icons.clear))
                      ],
                    ),
                  )
                : ScaffoldMessenger.of(context).clearMaterialBanners();
            isShowBanner = !isShowBanner;
          },
        )
      ],
    );
  }

  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      title: !isSearching
          ? const Text('Flutibre')
          : TextField(
              onSubmitted: (value) => ref
                  .read(bookListProvider.notifier)
                  .filteredBookItemList(value),
              cursorColor: Colors.white,
              style: Theme.of(context).textTheme.titleMedium,
              decoration: const InputDecoration(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                hintText: 'Search book',
                //hintStyle: TextStyle(color: Colors.white)
              ),
            ),
      actions: <Widget>[
        isSearching
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isSearching = false;
                    searchController.clear();
                    ref.read(bookListProvider.notifier).loadBookItemList();
                  });
                },
                icon: const Icon(Icons.cancel))
            : IconButton(
                onPressed: () {
                  setState(() {
                    isSearching = true;
                  });
                },
                icon: const Icon(Icons.search))
      ],
    );
  }
}
