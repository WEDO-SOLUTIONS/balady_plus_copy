part of 'general_inquiry_bloc.dart';

abstract class GeneralInquiryEvent extends Equatable {
  const GeneralInquiryEvent();

  @override
  List<Object> get props => [];
}

class GoToNextPageEvent extends GeneralInquiryEvent {
  GoToNextPageEvent();
}

class GoToPreviousPageEvent extends GeneralInquiryEvent {
  GoToPreviousPageEvent();
}
