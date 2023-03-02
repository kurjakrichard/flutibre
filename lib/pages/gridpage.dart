import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart';
import '../model/booklist_item.dart';

class GridPage extends ConsumerWidget {
  const GridPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int size = MediaQuery.of(context).size.width.round();
    AsyncValue<List<BookListItem>> itemValue = ref.watch(booklistProvider);
    return itemValue.when(
      data: (item) => Padding(
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
                                  '${prefs.getString('path')!}/${item[index].path}/cover.jpg'),
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
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text(e.toString())),
    );
  }
}
