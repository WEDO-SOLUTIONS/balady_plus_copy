part of 'transaction_inquiry_bloc.dart';

abstract class TransactionInquiryEvent extends Equatable {
  const TransactionInquiryEvent();

  @override
  List<Object> get props => [];
}

class GoToNextPageEvent extends TransactionInquiryEvent {
  GoToNextPageEvent();
}

class GoToPreviousPageEvent extends TransactionInquiryEvent {
  GoToPreviousPageEvent();
}
