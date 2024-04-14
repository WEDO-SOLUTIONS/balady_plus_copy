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

class CreateFormEvent extends SubmitRequestEvent {
  final String? serviceId;
  const CreateFormEvent({this.serviceId});
}

class ChangeTextComponentEvent extends SubmitRequestEvent {
  final String? text;
  final String fieldId;
  const ChangeTextComponentEvent({this.text, required this.fieldId});
}

class GetFormFieldDataEvent extends SubmitRequestEvent {
  final String? fieldId;
  const GetFormFieldDataEvent({required this.fieldId});
}

class SelectFormFieldDataEvent extends SubmitRequestEvent {
  final String? fieldId;
  final DropDownItem? item;
  const SelectFormFieldDataEvent({required this.fieldId, required this.item});
}

class ValidateFormEvent extends SubmitRequestEvent {
  final SubmitParams params;
  const ValidateFormEvent({required this.params});
}
