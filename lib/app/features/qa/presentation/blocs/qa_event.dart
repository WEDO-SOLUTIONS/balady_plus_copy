part of 'qa_bloc.dart';

abstract class QADataEvent extends Equatable {
  const QADataEvent();

  @override
  List<Object?> get props => [];
}

class GetQADataEvent extends QADataEvent {
  const GetQADataEvent();
}

class GetQADatSearchedaEvent extends QADataEvent {
  final String? text;
  const GetQADatSearchedaEvent({this.text});
}
