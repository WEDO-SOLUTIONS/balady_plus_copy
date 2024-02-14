part of 'enquiry_objection_bloc.dart';

abstract class EnquiryObjectionEvent extends Equatable {
  const EnquiryObjectionEvent();

  @override
  List<Object> get props => [];
}

class GetEnquiryObjectionEvent extends EnquiryObjectionEvent {
  const GetEnquiryObjectionEvent();
}
