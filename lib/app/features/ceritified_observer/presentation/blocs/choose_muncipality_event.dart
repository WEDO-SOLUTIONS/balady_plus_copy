part of 'choose_muncipality_bloc.dart';

abstract class ChooseMuncipalityEvent extends Equatable {
  const ChooseMuncipalityEvent();

  @override
  List<Object> get props => [];
}

class setRequestDataEvent extends ChooseMuncipalityEvent {
  final RegisterObserverRequest? dataModel;
  const setRequestDataEvent({this.dataModel});
}

class GoToNextPageEvent extends ChooseMuncipalityEvent {
  const GoToNextPageEvent();
}

class GoToPreviousPageEvent extends ChooseMuncipalityEvent {
  const GoToPreviousPageEvent();
}


