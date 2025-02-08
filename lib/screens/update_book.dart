import 'package:flutibre/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import '../config/config.dart';
import '../data/data_export.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

class UpdateBook extends ConsumerStatefulWidget {
  static UpdateBook builder(
    BuildContext context,
    GoRouterState state,
  ) =>
      const UpdateBook();
  const UpdateBook({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateBookScreenState();
}

class _UpdateBookScreenState extends ConsumerState<UpdateBook> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int? id;
  String? format;
  String? oldPath;
  String? oldFilename;
  Book? selectedBook;
  FileService fileService = FileService();

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    selectedBook = ref.watch(selectedBookProvider);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    if (selectedBook != null) {
      _titleController.text = selectedBook!.title;
      _authorController.text = selectedBook!.author;
      _descriptionController.text = selectedBook!.description;
      id = selectedBook!.id;
      format = selectedBook!.format;
      oldPath = selectedBook!.path;
      oldFilename = selectedBook!.filename;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary,
        title: const DisplayWhiteText(
          text: 'Update book',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonTextField(
                hintText: 'Title',
                title: 'Title',
                controller: _titleController,
              ),
              const Gap(30),
              CommonTextField(
                hintText: 'Author',
                title: 'Author',
                controller: _authorController,
              ),
              const Gap(30),
              const SelectDateTime(),
              const Gap(30),
              CommonTextField(
                hintText: 'Description',
                title: 'Description',
                maxLines: 6,
                controller: _descriptionController,
              ),
              const Gap(30),
              ElevatedButton(
                onPressed: _updateBook,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: DisplayWhiteText(
                    text: 'Save',
                  ),
                ),
              ),
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }

  void _updateBook() async {
    final title = _titleController.text.trim();
    final author = _authorController.text.trim();
    final description = _descriptionController.text.trim();
    final date = ref.watch(dateProvider);
    String? path;
    String? filename;
    if (title.isNotEmpty) {
      path = '${removeDiacritics(author)}/${removeDiacritics(title)}';
      filename = '${removeDiacritics(author)} - ${removeDiacritics(title)}';
      final book = ref.watch(selectedBookProvider)!.copyWith(
            title: title,
            author: author,
            path: path,
            filename: filename,
            last_modified: DateFormat.yMMMd().format(date),
            description: description,
          );
      ref.read(selectedBookProvider.notifier).setSelectedBook(book);
      await ref.read(booksProvider.notifier).updateBook(book).then((value) {
        // ignore: use_build_context_synchronously
        AppAlerts.displaySnackbar(context, 'Update book successfully');
        // ignore: use_build_context_synchronously
        context.go(RouteLocation.home);
      });
      await fileService.copyFile(
          oldpath:
              '/home/sire/Dokumentumok/ebooks/$oldPath/$oldFilename.${book.format}',
          newpath:
              '/home/sire/Dokumentumok/ebooks/$path/$filename.${book.format}');
      await fileService.deleteBook('/home/sire/Dokumentumok/ebooks/$oldPath');
    } else {
      AppAlerts.displaySnackbar(context, 'Title cannot be empty');
    }
  }
}
