import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutibre/data/data_export.dart';
import 'package:flutibre/utils/utils.dart';
import '../providers/providers.dart';

@immutable
class AppAlerts {
  static FileService fileService = FileService();

  const AppAlerts._();

  static displaySnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: context.textTheme.bodyMedium,
        ),
        backgroundColor: context.colorScheme.onSecondary,
      ),
    );
  }

  static Future<void> showAlertDeleteDialog({
    required BuildContext context,
    required WidgetRef ref,
    required Book book,
  }) async {
    Widget cancelButton = TextButton(
      child: const Text('NO'),
      onPressed: () => context.pop(),
    );
    Widget deleteButton = TextButton(
      onPressed: () async {
        await ref.read(booksProvider.notifier).deleteBook(book).then(
          (value) {
            displaySnackbar(
              context,
              'Book deleted successfully',
            );

            ref.read(selectedBookProvider.notifier).resetSelectedBook();
            context.pop();
          },
        );
        await fileService
            .deleteBook('/home/sire/Dokumentumok/ebooks/${book.path}');
      },
      child: const Text('YES'),
    );

    AlertDialog alert = AlertDialog(
      title: const Text('Are you sure you want to delete this book?'),
      actions: [
        deleteButton,
        cancelButton,
      ],
    );

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
