part of 'step3_conclusion_cubit.dart';


abstract class ConclusionEvent extends Equatable {
  const ConclusionEvent();

  @override
  List<Object> get props => [];
}



class InitWorkFlowNameEvent extends ConclusionEvent {
  final String? name;
  const InitWorkFlowNameEvent({this.name});
}


