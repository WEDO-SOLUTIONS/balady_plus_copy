part of 'transaction_details_bloc.dart';

abstract class TransactionDetailsEvent extends Equatable {
  const TransactionDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetObjectionDetailsEvent extends TransactionDetailsEvent {
  final String params;
  GetObjectionDetailsEvent({required this.params});
}

class GetGisLocationInfoEvent extends TransactionDetailsEvent {
  final double? lat;
  final double? lon;
  const GetGisLocationInfoEvent({this.lat, this.lon});
}

class ValidateObjectionDetailsTransactions extends TransactionDetailsEvent {
  const ValidateObjectionDetailsTransactions();
}
