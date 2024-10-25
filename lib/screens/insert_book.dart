import 'package:flutibre/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../config/config.dart';
import '../data/data_export.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

class InsertBook extends ConsumerStatefulWidget {
  static InsertBook builder(
    BuildContext context,
    GoRouterState state,
  ) =>
      const InsertBook();
  const InsertBook({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateTaskScreenState();
}

class _CreateTaskScreenState extends ConsumerState<InsertBook> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary,
        title: const DisplayWhiteText(
          text: 'Insert book',
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
                onPressed: _insertBook,
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

  void _insertBook() async {
    final title = _titleController.text.trim();
    final author = _authorController.text.trim();
    final description = _descriptionController.text.trim();
    final date = ref.watch(dateProvider);
    if (title.isNotEmpty) {
      final book = Book(
        title: title,
        author: author,
        price: '100 Ft',
        image: 'res/corel.jpg',
        path: 'res/Richard Powers - Orfeo.epub',
        last_modified: DateFormat.yMMMd().format(date),
        description: description,
        rating: 1.0,
        pages: 0,
      );

      await ref.read(booksProvider.notifier).addBook(book).then((value) {
        AppAlerts.displaySnackbar(context, 'Update book successfully');
        context.go(RouteLocation.home);
      });
    } else {
      AppAlerts.displaySnackbar(context, 'Title cannot be empty');
    }
  }
}
