part of 'extra_data_bloc.dart';


abstract class ExtraDataEvent extends Equatable {
  const ExtraDataEvent();

  @override
  List<Object> get props => [];
}


class GetDeceasedAttachmentEvent extends ExtraDataEvent {
  int requestId;
   GetDeceasedAttachmentEvent({required this.requestId});
}

class DownLoadDeceasedAttachmentEvent extends ExtraDataEvent {
  final int id;
  const DownLoadDeceasedAttachmentEvent({required this.id});
}
class UploadDeceasedAttachmentEvent extends ExtraDataEvent {
  final FileDataItem? file;
  final int? attachmentId;
  final int? requestId;
  const UploadDeceasedAttachmentEvent({this.file, this.attachmentId, this.requestId});

}

class DeleteDeceasedAttachmentEvent extends ExtraDataEvent {
  final DeceasedAttachment? item;
  int? requestId;
   DeleteDeceasedAttachmentEvent({this.item,this.requestId});

}

class GetGhuslEmployeesEvent extends ExtraDataEvent {
  int requestId;
  String? ghuslEmployeeIdentityNo;
   GetGhuslEmployeesEvent({required this.requestId,required this.ghuslEmployeeIdentityNo});
}
class EditAdditionalDataEvent extends ExtraDataEvent {
  int requestId;

  EditAdditionalDataEvent({required this.requestId});
}
class SetSelectEmployeeEvent extends ExtraDataEvent {
  int requestId;
  GhuslEmploye employee;
  SetSelectEmployeeEvent({required this.requestId,required this.employee});
}

