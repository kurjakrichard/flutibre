import 'package:flutibre/models/book_data.dart';
import 'package:flutibre/utils/book_repository.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ModifyBookPage extends StatelessWidget {
  const ModifyBookPage({Key? key, required this.title, required this.size})
      : super(key: key);

  final int size;
  final String title;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var result = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              TextButton(
                child: const Text(
                  'Leave',
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
                      decoration: const InputDecoration(
                          icon: Icon(Icons.book),
                          labelText: 'Title',
                          hintText: 'Book title',
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.text,
                      validator: MinLengthValidator(1,
                          errorText: 'Title is required!'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: FormBuilderTextField(
                        name: 'author',
                        decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: 'Author',
                            hintText: 'Book author',
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.name,
                        validator: MinLengthValidator(1,
                            errorText: 'Author is required!'),
                      ),
                    ),
                    FormBuilderTextField(
                      name: 'language',
                      decoration: const InputDecoration(
                          icon: Icon(Icons.language),
                          labelText: 'Language',
                          hintText: 'Language',
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.text,
                      validator: MinLengthValidator(1,
                          errorText: 'Language is required!'),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Builder(builder: (context) {
                          return ElevatedButton(
                              child: Text('Create',
                                  style: Theme.of(context).textTheme.headline3),
                              onPressed: () {
                                var form = FormBuilder.of(context)!;

                                if (form.saveAndValidate()) {
                                  var book = BookData(
                                      size + 1,
                                      form.value['author']!,
                                      form.value['title']!,
                                      '',
                                      form.value['language']!,
                                      '',
                                      '',
                                      'images/16.jpg');
                                  BookRepository.of(context).onBookAdded(book);
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
