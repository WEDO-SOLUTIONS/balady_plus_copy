part of 'edit_bidding_form_bloc.dart';

abstract class EditBiddingFormEvent extends Equatable {
  const EditBiddingFormEvent();

  @override
  List<Object> get props => [];
}

class GetBiddingFormEvent extends EditBiddingFormEvent {
  final String params;
  const GetBiddingFormEvent({required this.params});
}

class GoToNextPageEvent extends EditBiddingFormEvent {
  GoToNextPageEvent();
}

class GoToPreviousPageEvent extends EditBiddingFormEvent {
  GoToPreviousPageEvent();
}

class ChangeTextComponentEvent extends EditBiddingFormEvent {
  final String? text;
  final String fieldId;
  const ChangeTextComponentEvent({this.text, required this.fieldId});
}

class GetFormFieldDataEvent extends EditBiddingFormEvent {
  final String? fieldId;
  const GetFormFieldDataEvent({required this.fieldId});
}

class SelectFormFieldDataEvent extends EditBiddingFormEvent {
  final String? fieldId;
  final DropDownItem? item;
  const SelectFormFieldDataEvent({required this.fieldId, required this.item});
}

class SubmitFormEvent extends EditBiddingFormEvent {
  const SubmitFormEvent();
}

class ValidateFormEvent extends EditBiddingFormEvent {
  const ValidateFormEvent();
}
