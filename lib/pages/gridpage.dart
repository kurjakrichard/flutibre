import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../main.dart';
import '../model/booklist_item.dart';

class GridPage extends ConsumerStatefulWidget {
  const GridPage({Key? key}) : super(key: key);

  @override
  ConsumerState<GridPage> createState() => _GridPageState();
}

class _GridPageState extends ConsumerState<GridPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    int size = MediaQuery.of(context).size.width.round();
    AsyncValue<List<BookListItem>> itemValue = ref.watch(booklistProvider);
    return itemValue.when(
      data: (item) => item.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(4.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (size / 150).round(),
                  crossAxisSpacing: 10,
                  childAspectRatio: 2 / 3,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return Center(
                    child: RawMaterialButton(
                      onPressed: () async {},
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: item[index].has_cover == 1
                                ? FileImage(
                                    File(
                                        '${item[index].fullPath}/${item[index].path}/cover.jpg'),
                                  )
                                : Image.asset('images/cover.png').image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: item.length,
              ),
            )
          : Center(
              child: Text(AppLocalizations.of(context)!.emptylibrary,
                  style: const TextStyle(fontSize: 20, color: Colors.grey))),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text(e.toString())),
    );
  }
}
