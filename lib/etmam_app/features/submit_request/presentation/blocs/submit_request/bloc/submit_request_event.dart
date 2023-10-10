part of 'submit_request_bloc.dart';

abstract class SubmitRequestEvent extends Equatable {
  const SubmitRequestEvent();

  @override
  List<Object> get props => [];
}

class SubmitEvent extends SubmitRequestEvent {
  SubmitParams params;
  SubmitEvent({required this.params});
}

class DeleteSubReleation extends SubmitRequestEvent {
  String id;
  DeleteSubReleation({required this.id});
}
