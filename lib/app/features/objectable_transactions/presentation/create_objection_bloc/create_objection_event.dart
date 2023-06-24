part of 'create_objection_bloc.dart';

abstract class CreateObjectionEvent extends Equatable {
  const CreateObjectionEvent();

  @override
  List<Object> get props => [];
}

class GetMyVehiclesEvent extends CreateObjectionEvent {
  GetMyVehiclesEvent();
}

class ChangeIssueDescEvent extends CreateObjectionEvent {
  final String? text;
  final int index;
  ChangeIssueDescEvent({this.text, required this.index});
}

class UploadFileEvent extends CreateObjectionEvent {
  final FileDataItem params;
  final int index;
  UploadFileEvent({required this.params, required this.index});
}

class SubmitIncidentEvent extends CreateObjectionEvent {
  SubmitIncidentEvent();
}

class CreateIncidentRegisteredEvent extends CreateObjectionEvent {
  CreateIncidentRegisteredEvent();
}

class AddNewReasonEvent extends CreateObjectionEvent {
  AddNewReasonEvent();
}

class GoToNextPageEvent extends CreateObjectionEvent {
  GoToNextPageEvent();
}

class GoToPreviousPageEvent extends CreateObjectionEvent {
  GoToPreviousPageEvent();
}
