part of 'qa_bloc.dart';

abstract class QADataEvent extends Equatable {
  const QADataEvent();

  @override
  List<Object?> get props => [];
}

class GetQADataEvent extends QADataEvent {
  const GetQADataEvent();
}
