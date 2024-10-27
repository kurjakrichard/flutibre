import 'package:flutibre/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/data_export.dart';
import '../providers/providers.dart';

class BookDetails extends ConsumerWidget {
  const BookDetails({super.key});

  static BookDetails builder(
    BuildContext context,
    GoRouterState state,
  ) =>
      const BookDetails();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Book? selectedBook = ref.watch(selectedBookProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedBook!.title),
      ),
      body: const Detail(
        isPage: true,
      ),
    );
  }
}
