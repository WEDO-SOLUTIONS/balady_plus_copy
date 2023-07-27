part of 'new_daem_ticket_bloc.dart';

abstract class NewDaemTicketEvent {}

class GetDaemCategoriesEvent extends NewDaemTicketEvent {}

class GetDaemSubCategoriesEvent extends NewDaemTicketEvent {
  DaemItem category;
  GetDaemSubCategoriesEvent({required this.category});
}

class GetDaemAreaListEvent extends NewDaemTicketEvent {
  DaemItem category;
  DaemItem subCategory;
  GetDaemAreaListEvent({required this.category, required this.subCategory});
}

class GetDaemIssueTypeEvent extends NewDaemTicketEvent {
  DaemItem category;
  DaemItem subCategory;
  DaemItem area;
  GetDaemIssueTypeEvent(
      {required this.category, required this.subCategory, required this.area});
}

class SetIssueTypeEvent extends NewDaemTicketEvent {
  DaemItem issueType;
  SetIssueTypeEvent({required this.issueType});
}

class GetDaemSubMunicipalitiesEvent extends NewDaemTicketEvent {
  DaemItem municipality;

  GetDaemSubMunicipalitiesEvent({required this.municipality});
}

class SetSubMunicipalityEvent extends NewDaemTicketEvent {
  DaemItem subMunicipality;
  SetSubMunicipalityEvent({required this.subMunicipality});
}

class SetDescriptionEvent extends NewDaemTicketEvent {
  String text;
  SetDescriptionEvent({required this.text});
}

class AddAttachmentFileEvent extends NewDaemTicketEvent {
  int index;
  String filePath;
  String fileName;
  String base64;
  AddAttachmentFileEvent(
      {required this.index,
      required this.filePath,
      required this.fileName,
      required this.base64});
}

class DeleteAttachmentFileEvent extends NewDaemTicketEvent {
  int index;
  DeleteAttachmentFileEvent(this.index);
}

class ValidateDaemFormEvent extends NewDaemTicketEvent {
  ValidateDaemFormEvent();
}

class CreateTicketEvent extends NewDaemTicketEvent {
  CreateTicketEvent();
}

class UploadTicketFilesEvent extends NewDaemTicketEvent {
  UploadTicketFilesEvent();
}

class GoToNextPageEvent extends NewDaemTicketEvent {
  GoToNextPageEvent();
}

class GoToPreviousPageEvent extends NewDaemTicketEvent {
  GoToPreviousPageEvent();
}
