import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../model/author.dart';
import '../model/book.dart';
import '../model/comment.dart';
import '../providers/booklist_provider.dart';
import '../repository/database_handler.dart';
import '../utils/constants.dart';

class UpdatePage extends ConsumerStatefulWidget {
  const UpdatePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  ConsumerState<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends ConsumerState<UpdatePage> {
  final DatabaseHandler _databaseHandler = DatabaseHandler();
  Book? book;

  @override
  void initState() {
    _databaseHandler.getAuthorList();
    // book =     widget.addingBook ? _databaseHandler.getBookById(widget.bookId!) : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var routeSettings = ModalRoute.of(context)!.settings;
    if (routeSettings.arguments != null) {
      book = routeSettings.arguments as Book;
    } else {
      book = null;
    }
    return WillPopScope(
      onWillPop: () async {
        var result = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.confirmation),
            actions: [
              TextButton(
                child: Text(AppLocalizations.of(context)!.cancel),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.ok,
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          ),
        );
        return result;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          var isWide = constraints.maxWidth < maxWidth;
          if (!isWide) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  listView(600),
                  const Expanded(child: Placeholder())
                ]);
          } else {
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  listView(maxWidth),
                  const SingleChildScrollView(
                      child: SizedBox(height: 50, child: Placeholder()))
                ]);
          }
        }),
      ),
    );
  }

  Widget listView(double width) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FormBuilder(
        child: SizedBox(
          width: width,
          height: 270,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              const SizedBox(
                height: 10,
              ),
              textField(
                  context: context,
                  name: 'title',
                  initialValue: book?.title,
                  icon: Icons.book,
                  labelText: AppLocalizations.of(context)!.title,
                  hintText: AppLocalizations.of(context)!.title,
                  errorText: AppLocalizations.of(context)!.titlerequired),
              textField(
                  context: context,
                  name: 'author',
                  initialValue: book?.authors?[0].name,
                  icon: Icons.person,
                  labelText: AppLocalizations.of(context)!.author,
                  hintText: AppLocalizations.of(context)!.author,
                  errorText: AppLocalizations.of(context)!.authorrequired),
              textField(
                  context: context,
                  name: 'comment',
                  initialValue: book?.comment?.text ?? ' ',
                  icon: Icons.comment,
                  labelText: AppLocalizations.of(context)!.comment,
                  hintText: AppLocalizations.of(context)!.comment,
                  errorText: AppLocalizations.of(context)!.commentrequired),
              Builder(builder: (context) {
                return Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          child: Text(
                            AppLocalizations.of(context)!.create,
                          ),
                          onPressed: () {
                            var form = FormBuilder.of(context)!;

                            if (form.saveAndValidate()) {
                              var book = Book(
                                  title: form.value['title']!,
                                  authors: [
                                    Author(id: 1, name: form.value['author'])
                                  ],
                                  author_sort: form.value['author'],
                                  comment:
                                      const Comment(book: 1, id: 1, text: ''),
                                  formats: const [],
                                  has_cover: 0,
                                  isbn: '',
                                  last_modified: '',
                                  lccn: '',
                                  path: '',
                                  pubdate: '',
                                  series_index: 0,
                                  sort: '',
                                  timestamp: '');
                              ref
                                  .read(bookListProvider.notifier)
                                  .insertBook(book);
                              Navigator.pop(context);
                            }
                          }),
                    ),
                  ],
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget textField(
      {BuildContext? context,
      required String name,
      String? initialValue,
      required IconData icon,
      required String labelText,
      required String hintText,
      required String errorText}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: FormBuilderTextField(
        name: name,
        initialValue: initialValue ?? '',
        decoration: InputDecoration(
            icon: Icon(icon),
            labelText: labelText,
            hintText: hintText,
            border: const OutlineInputBorder()),
        keyboardType: TextInputType.text,
        validator: MinLengthValidator(1, errorText: errorText),
      ),
    );
  }
}
