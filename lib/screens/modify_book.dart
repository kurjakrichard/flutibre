import 'package:flutter/material.dart';

class ModifyBookPage extends StatelessWidget {
  const ModifyBookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add book'),
      ),
      body: Center(
        child: Container(
          width: 600,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        icon: Icon(Icons.book),
                        labelText: 'Title',
                        hintText: 'Book title',
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.text,
                    onSaved: (value) {},
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          labelText: 'Author',
                          hintText: 'Book author',
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.name,
                      onSaved: (value) {},
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        icon: Icon(Icons.language),
                        labelText: 'Language',
                        hintText: 'Language',
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.text,
                    onSaved: (value) {},
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          child: Text('Create',
                              style: Theme.of(context).textTheme.headline3),
                          onPressed: () {}),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
