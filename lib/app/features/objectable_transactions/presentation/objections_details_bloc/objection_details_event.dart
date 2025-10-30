part of 'objection_details_bloc.dart';

abstract class ObjectionDetailsEvent extends Equatable {
  const ObjectionDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetTransactionDetailsEvent extends ObjectionDetailsEvent {
  final TransactionDetailsParams params;
  final bool apply;
  final bool refresh;
  GetTransactionDetailsEvent(
      {required this.params, this.apply = false, this.refresh = false});
}

class CancelObjectionEvent extends ObjectionDetailsEvent {}

class GetObjectionDetailsEvent extends ObjectionDetailsEvent {
  final String params;

  GetObjectionDetailsEvent({required this.params});
}

class OpenObjectableDetails extends ObjectionDetailsEvent {
  const OpenObjectableDetails();
}
