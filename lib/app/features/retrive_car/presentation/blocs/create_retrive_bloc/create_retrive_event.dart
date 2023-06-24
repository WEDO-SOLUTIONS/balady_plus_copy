part of 'create_retrive_bloc.dart';

abstract class CreateRetriveCarEvent extends Equatable {
  const CreateRetriveCarEvent();

  @override
  List<Object> get props => [];
}

class GoToNextPageEvent extends CreateRetriveCarEvent {
  GoToNextPageEvent();
}

class GoToPreviousPageEvent extends CreateRetriveCarEvent {
  GoToPreviousPageEvent();
}

class ChangeIssueDescEvent extends CreateRetriveCarEvent {
  final String? text;
  ChangeIssueDescEvent({this.text});
}

class UploadFileEvent extends CreateRetriveCarEvent {
  final FileDataItem params;
  UploadFileEvent({required this.params});
}

class SubmitIncidentEvent extends CreateRetriveCarEvent {
  final String? otpValue;
  final CreateIncidentParams? params;

  SubmitIncidentEvent({this.otpValue, this.params});
}

class CreateIncidentRegisteredEvent extends CreateRetriveCarEvent {
  final CreateIncidentParams? params;
  CreateIncidentRegisteredEvent({this.params});
}

class ChangeAgreementEvent extends CreateRetriveCarEvent {
  final bool? isagree;
  ChangeAgreementEvent({this.isagree});
}

class ChangeDateEvent extends CreateRetriveCarEvent {
  final String? date;
  ChangeDateEvent({this.date});
}

class DeleteFileEvent extends CreateRetriveCarEvent {
  const DeleteFileEvent();
}
