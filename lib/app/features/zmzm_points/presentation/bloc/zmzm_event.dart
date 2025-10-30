part of 'zmzm_bloc.dart';

abstract class ZmZmEvent extends Equatable {
  const ZmZmEvent();

  @override
  List<Object> get props => [];
}

class GoToNextPageEvent extends ZmZmEvent {
  GoToNextPageEvent();
}

class GoToPreviousPageEvent extends ZmZmEvent {
  GoToPreviousPageEvent();
}

class initZmZmEvent extends ZmZmEvent {
  initZmZmEvent();
}

class ChangeCityEvent extends ZmZmEvent {
  final String city;
  const ChangeCityEvent({required this.city});
}
