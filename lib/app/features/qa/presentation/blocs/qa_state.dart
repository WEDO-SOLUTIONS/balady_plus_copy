part of 'qa_bloc.dart';

class QAState extends Equatable {
  //error message
  final String? errorMessage;
  final List<QAModel>? list;

  const QAState({this.errorMessage, this.list});

  QAState copyWith({String? errorMessage, List<QAModel>? list}) {
    return QAState(
        errorMessage: errorMessage ?? this.errorMessage,
        list: list ?? this.list);
  }

  QAState clearFilters() => QAState(
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [errorMessage, list];
}
