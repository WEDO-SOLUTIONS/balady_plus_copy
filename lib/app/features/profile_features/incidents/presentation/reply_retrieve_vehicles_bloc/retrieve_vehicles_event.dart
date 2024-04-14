part of 'retrieve_vehicles_bloc.dart';

abstract class ReplyRetrieveVehiclesEvent extends Equatable {
  const ReplyRetrieveVehiclesEvent();

  @override
  List<Object> get props => [];
}

class GetMyVehiclesEvent extends ReplyRetrieveVehiclesEvent {
  GetMyVehiclesEvent();
}

class ChangeIssueDescEvent extends ReplyRetrieveVehiclesEvent {
  final String? text;
  ChangeIssueDescEvent({this.text});
}

class UploadFileEvent extends ReplyRetrieveVehiclesEvent {
  final FileDataItem params;
  UploadFileEvent({required this.params});
}

class SubmitIncidentEvent extends ReplyRetrieveVehiclesEvent {
  SubmitIncidentEvent();
}

class CreateIncidentRegisteredEvent extends ReplyRetrieveVehiclesEvent {
  CreateIncidentRegisteredEvent();
}
