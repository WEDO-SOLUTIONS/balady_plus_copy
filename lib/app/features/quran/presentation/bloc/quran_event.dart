part of 'quran_bloc.dart';

abstract class QuranEvent extends Equatable {
  const QuranEvent();

  @override
  List<Object> get props => [];
}

class GoToNextPageEvent extends QuranEvent {
  GoToNextPageEvent();
}

class GoToPreviousPageEvent extends QuranEvent {
  GoToPreviousPageEvent();
}

class initQuranEvent extends QuranEvent {
  initQuranEvent();
}

class ChangePageEvent extends QuranEvent {
  final int? page;
  ChangePageEvent({this.page});
}

class ToggleDetailsEvent extends QuranEvent {
  ToggleDetailsEvent();
}

class MoveToPageEvent extends QuranEvent {
  final int page;
  MoveToPageEvent({required this.page});
}

class SaveBookMarkEvent extends QuranEvent {
  SaveBookMarkEvent();
}
