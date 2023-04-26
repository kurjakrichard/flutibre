import 'package:flutibre/model/booklist_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/book_list_state.dart';
import '../providers/booklist_provider2.dart';

class BookListPage2 extends StatelessWidget {
  const BookListPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BookListPageState();
  }
}

class BookListPageState extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookListProvider2);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod SQLite Crud'),
        actions: <Widget>[
          // desativar o botao de excluir todas as notas se nao ha notas
          state is BookListEmpty
              ? const IconButton(
                  onPressed: null,
                  icon: Icon(Icons.clear_all),
                )
              : IconButton(
                  icon: const Icon(Icons.clear_all),
                  onPressed: () {
                    // excluir todas as notas
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Excluir Todas as Notas'),
                        content: const Text('Confirmar operação?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              ref
                                  .read(bookListProvider2.notifier)
                                  .loadBookItemList();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(const SnackBar(
                                  content: Text('Notas excluídas com sucesso'),
                                ));
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                )
        ],
      ),
      body: const _Content(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          /* Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteEditPage(note: null)),
          );*/
        },
      ),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookListProvider2);
    if (state is BookListInitial) {
      return const SizedBox();
    } else if (state is BookListLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is BookListEmpty) {
      return const Center(
        child: Text('No books'),
      );
    } else if (state is BookListLoaded) {
      return _BookList(state.bookList);
    } else {
      return const Text('Error');
    }
  }
}

class _BookList extends StatelessWidget {
  const _BookList(
    List<BookListItem>? this.bookList, {
    Key? key,
  }) : super(key: key);
  final bookList;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final book in bookList) ...[
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text(book.title),
              subtitle: Text(
                '${book.name}',
              ),
              trailing: Wrap(children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    /* Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NoteEditPage(note: note)),
                    );*/
                  },
                ),
                IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // excluir nota atraves do id
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Excluir Nota'),
                          content: const Text('Confirmar operação?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar'),
                            ),
                            Consumer(builder: (context, ref, _) {
                              return TextButton(
                                onPressed: () {
                                  ref
                                      .read(bookListProvider2.notifier)
                                      .editBook(book.id);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(const SnackBar(
                                      content:
                                          Text('Nota excluída com sucesso'),
                                    ));
                                },
                                child: const Text('OK'),
                              );
                            }),
                          ],
                        ),
                      );
                    }),
              ]),
            ),
          ),
        ],
      ],
    );
  }
}
