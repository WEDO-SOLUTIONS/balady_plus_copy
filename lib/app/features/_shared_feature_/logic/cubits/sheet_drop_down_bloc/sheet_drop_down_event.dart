part of 'sheet_drop_down_bloc.dart';

abstract class SheetDropDownEvent extends Equatable {
  const SheetDropDownEvent();

  @override
  List<Object> get props => [];
}

class OnUpdating extends SheetDropDownEvent {
  final int index;

  const OnUpdating({required this.index});

  @override
  List<Object> get props => [index];
}

class OnSearching extends SheetDropDownEvent {
  final String query;

  const OnSearching({required this.query});

  @override
  List<Object> get props => [query];
}

class OnBackToDefault extends SheetDropDownEvent {
  const OnBackToDefault();
}
