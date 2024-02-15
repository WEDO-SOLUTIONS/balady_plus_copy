part of 'enquiry_objection_bloc.dart';

abstract class EnquiryObjectionEvent extends Equatable {
  const EnquiryObjectionEvent();

  @override
  List<Object> get props => [];
}

class GetEnquiryObjectionEvent extends EnquiryObjectionEvent {
  const GetEnquiryObjectionEvent();
}

class ChangeIssueDescEvent extends EnquiryObjectionEvent {
  final String? text;
  final int index;
  const ChangeIssueDescEvent({this.text, required this.index});
}

class UploadFileEvent extends EnquiryObjectionEvent {
  final FileDataItem params;
  final int index;
  const UploadFileEvent({required this.params, required this.index});
}

class RemoveFileEvent extends EnquiryObjectionEvent {
  final int index;
  const RemoveFileEvent({required this.index});
}

class SubmitIncidentEvent extends EnquiryObjectionEvent {
  const SubmitIncidentEvent();
}

class CreateIncidentRegisteredEvent extends EnquiryObjectionEvent {
  const CreateIncidentRegisteredEvent();
}

class DeleteNewReasonEvent extends EnquiryObjectionEvent {
  final int index;
  const DeleteNewReasonEvent({required this.index});
}
