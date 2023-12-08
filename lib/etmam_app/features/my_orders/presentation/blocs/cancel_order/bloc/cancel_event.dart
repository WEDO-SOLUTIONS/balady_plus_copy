part of 'cancel_bloc.dart';

abstract class CancelEvent extends Equatable {
  const CancelEvent();

  @override
  List<Object> get props => [];
}

class CencelOrderEvent extends CancelEvent {
  CancelOrderParams params;
  CencelOrderEvent({required this.params});
}
