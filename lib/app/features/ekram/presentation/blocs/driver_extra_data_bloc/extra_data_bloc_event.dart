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

class GetGhuslEmployeesEvent extends ExtraDataEvent {
  int requestId;
   GetGhuslEmployeesEvent({required this.requestId});
}
class SetSelectEmployeeEvent extends ExtraDataEvent {
  int requestId;
  GhuslEmploye employee;
  SetSelectEmployeeEvent({required this.requestId,required this.employee});
}

