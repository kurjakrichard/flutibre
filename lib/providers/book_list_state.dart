import '../model/booklist_item.dart';

abstract class BookListState {
  BookListState();
}

class BookListInitial extends BookListState {
  BookListInitial();
}

class BookListLoading extends BookListState {
  BookListLoading();
}

class BookListLoaded extends BookListState {
  BookListLoaded({
    this.bookList,
  });

  final List<BookListItem>? bookList;
}

class BookListEmpty extends BookListState {
  BookListEmpty();
}

class BookListFailure extends BookListState {
  BookListFailure();
}

class BookListSuccess extends BookListState {
  BookListSuccess();
}
