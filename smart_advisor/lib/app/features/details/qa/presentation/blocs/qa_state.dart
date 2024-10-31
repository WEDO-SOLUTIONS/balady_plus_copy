part of 'qa_bloc.dart';

class QAState extends Equatable {
  //error message
  final String? errorMessage;
  final List<QAModel>? list;
  final BlocStatus status;
  final List<QAModel>? filtered;

  const QAState(
      {this.errorMessage,
      this.list,
      this.filtered,
      this.status = BlocStatus.initial});

  QAState copyWith(
      {String? errorMessage,
      List<QAModel>? list,
      List<QAModel>? filtered,
      BlocStatus? status}) {
    return QAState(
        errorMessage: errorMessage ?? this.errorMessage,
        status: status ?? this.status,
        filtered: filtered ?? this.filtered,
        list: list ?? this.list);
  }

  @override
  List<Object?> get props => [errorMessage, list, filtered, status];
}
