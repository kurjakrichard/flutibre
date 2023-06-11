import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../model/author.dart';
import '../model/book.dart';
import '../model/comment.dart';
import '../providers/booklist_provider.dart';

class AddEditPage extends ConsumerWidget {
  const AddEditPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          title: Text(title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: FormBuilder(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: FormBuilderTextField(
                    name: 'title',
                    decoration: InputDecoration(
                        icon: const Icon(Icons.book),
                        labelText: AppLocalizations.of(context)!.title,
                        hintText: AppLocalizations.of(context)!.title,
                        border: const OutlineInputBorder()),
                    keyboardType: TextInputType.text,
                    validator: MinLengthValidator(1,
                        errorText: AppLocalizations.of(context)!.titlerequired),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: FormBuilderTextField(
                    name: 'author',
                    decoration: InputDecoration(
                        icon: const Icon(Icons.person),
                        labelText: AppLocalizations.of(context)!.author,
                        hintText: AppLocalizations.of(context)!.author,
                        border: const OutlineInputBorder()),
                    keyboardType: TextInputType.name,
                    validator: MinLengthValidator(1,
                        errorText:
                            AppLocalizations.of(context)!.authorrequired),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: FormBuilderTextField(
                    name: 'language',
                    decoration: InputDecoration(
                        icon: const Icon(Icons.language),
                        labelText: AppLocalizations.of(context)!.language,
                        hintText: AppLocalizations.of(context)!.language,
                        border: const OutlineInputBorder()),
                    keyboardType: TextInputType.text,
                    validator: MinLengthValidator(1,
                        errorText:
                            AppLocalizations.of(context)!.languagerequired),
                  ),
                ),
                Builder(builder: (context) {
                  return ElevatedButton(
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
                              comment: const Comment(book: 1, id: 1, text: ''),
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
                          print(book.id);
                          ref.read(bookListProvider.notifier).insertBook(book);
                          Navigator.pop(context);
                        }
                      });
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
