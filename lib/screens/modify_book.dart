import 'package:flutibre/models/book_data.dart';
import 'package:flutibre/utils/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ModifyBookPage extends StatelessWidget {
  const ModifyBookPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
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
                            errorText:
                                AppLocalizations.of(context)!.authorrequired),
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
                          errorText:
                              AppLocalizations.of(context)!.languagerequired),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Builder(builder: (context) {
                          dynamic args =
                              ModalRoute.of(context)!.settings.arguments;
                          int size = args!['size'] as int;
                          size++;
                          return ElevatedButton(
                              child: Text(AppLocalizations.of(context)!.create,
                                  style: Theme.of(context).textTheme.headline3),
                              onPressed: () {
                                var form = FormBuilder.of(context)!;

                                if (form.saveAndValidate()) {
                                  var book = BookData(
                                      size,
                                      form.value['author']!,
                                      form.value['title']!,
                                      '',
                                      form.value['language']!,
                                      '',
                                      '',
                                      'images/$size.jpg');
                                  args.onBookAdd(book);
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
        ),
      ),
    );
  }
}
