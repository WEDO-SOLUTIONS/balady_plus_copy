import 'package:equatable/equatable.dart';

class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchIsicEvent extends SearchEvent {
  final String keyword;
  SearchIsicEvent({required this.keyword});
}
