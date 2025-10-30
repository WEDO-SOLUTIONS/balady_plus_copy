part of 'book_mark_bloc.dart';

abstract class BookMarkEvent extends Equatable {
  const BookMarkEvent();

  @override
  List<Object> get props => [];
}

class initBookMarkEvent extends BookMarkEvent {
  initBookMarkEvent();
}

class ChangePageEvent extends BookMarkEvent {
  final int? page;
  ChangePageEvent({this.page});
}

class ToggleDetailsEvent extends BookMarkEvent {
  ToggleDetailsEvent();
}
