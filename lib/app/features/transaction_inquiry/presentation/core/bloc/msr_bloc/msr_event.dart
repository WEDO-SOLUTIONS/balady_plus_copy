part of 'msr_bloc.dart';

abstract class MSREvent extends Equatable {
  const MSREvent();

  @override
  List<Object> get props => [];
}

class GoToNextPageEvent extends MSREvent {
  GoToNextPageEvent();
}

class GoToPreviousPageEvent extends MSREvent {
  GoToPreviousPageEvent();
}
