part of 'bidding_form_bloc.dart';

abstract class BiddingFormEvent extends Equatable {
  const BiddingFormEvent();

  @override
  List<Object> get props => [];
}

class GetBiddingFormEvent extends BiddingFormEvent {
  final CreateFormParams params;
  const GetBiddingFormEvent({required this.params});
}

class GoToNextPageEvent extends BiddingFormEvent {
  GoToNextPageEvent();
}

class GoToPreviousPageEvent extends BiddingFormEvent {
  GoToPreviousPageEvent();
}

class ChangeTextComponentEvent extends BiddingFormEvent {
  final String? text;
  final String fieldId;
  const ChangeTextComponentEvent({this.text, required this.fieldId});
}

class GetFormFieldDataEvent extends BiddingFormEvent {
  final String? fieldId;
  const GetFormFieldDataEvent({required this.fieldId});
}

class SelectFormFieldDataEvent extends BiddingFormEvent {
  final String? fieldId;
  final DropDownItem? item;
  const SelectFormFieldDataEvent({required this.fieldId, required this.item});
}

class SubmitFormEvent extends BiddingFormEvent {
  const SubmitFormEvent();
}

class ValidateFormEvent extends BiddingFormEvent {
  const ValidateFormEvent();
}

class UploadBiddingAttachmentEvent extends BiddingFormEvent {
  final FileDataItem file;
  const UploadBiddingAttachmentEvent({required this.file});
}

class RemoveBiddingAttachmentEvent extends BiddingFormEvent {
  const RemoveBiddingAttachmentEvent();
}
