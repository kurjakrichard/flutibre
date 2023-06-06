import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../model/book.dart';
import '../model/comment.dart';
import '../providers/booklist_provider.dart';

class AddEditPage extends ConsumerWidget {
  const AddEditPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int size = MediaQuery.of(context).size.width.round();
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
            body: Center(
              child: Container(
                width: 600,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: FormBuilder(
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          name: 'title',
                          decoration: InputDecoration(
                              icon: const Icon(Icons.book),
                              labelText: AppLocalizations.of(context)!.title,
                              hintText: AppLocalizations.of(context)!.title,
                              border: const OutlineInputBorder()),
                          keyboardType: TextInputType.text,
                          validator: MinLengthValidator(1,
                              errorText:
                                  AppLocalizations.of(context)!.titlerequired),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: FormBuilderTextField(
                            name: 'author',
                            decoration: InputDecoration(
                                icon: const Icon(Icons.person),
                                labelText: AppLocalizations.of(context)!.author,
                                hintText: AppLocalizations.of(context)!.author,
                                border: const OutlineInputBorder()),
                            keyboardType: TextInputType.name,
                            validator: MinLengthValidator(1,
                                errorText: AppLocalizations.of(context)!
                                    .authorrequired),
                          ),
                        ),
                        FormBuilderTextField(
                          name: 'language',
                          decoration: InputDecoration(
                              icon: const Icon(Icons.language),
                              labelText: AppLocalizations.of(context)!.language,
                              hintText: AppLocalizations.of(context)!.language,
                              border: const OutlineInputBorder()),
                          keyboardType: TextInputType.text,
                          validator: MinLengthValidator(1,
                              errorText: AppLocalizations.of(context)!
                                  .languagerequired),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Builder(builder: (context) {
                              return ElevatedButton(
                                  child: Text(
                                      AppLocalizations.of(context)!.create,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall),
                                  onPressed: () {
                                    var form = FormBuilder.of(context)!;

                                    if (form.saveAndValidate()) {
                                      var book = Book(
                                          title: form.value['title']!,
                                          authors: [form.value['author']],
                                          author_sort: form.value['author'],
                                          comment: Comment(),
                                          formats: [],
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
                                          .editBook(book);
                                      Navigator.pop(context);
                                    }
                                  });
                            }),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
