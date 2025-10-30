part of 'edit_bidding_form_bloc.dart';

class EditBiddingFormState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final CreateFormItemResponse? formResponses;
  final int currentPageValue;
  final EditBiddingPageParams params;
  final ValidateFormResponse? formValidation;

  const EditBiddingFormState(
      {this.status = BlocStatus.initial,
      this.currentPageValue = 0,
      this.errorMessage,
      this.formResponses,
      required this.params,
      this.formValidation});

  @override
  List<Object?> get props =>
      [status, errorMessage, currentPageValue, formValidation];

  EditBiddingFormState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      final CreateFormItemResponse? formResponses,
      final String? currentFormId,
      final int? currentPageValue,
      final ValidateFormResponse? formValidation}) {
    return EditBiddingFormState(
        errorMessage: errorMessage ?? this.errorMessage,
        status: status ?? this.status,
        formResponses: formResponses ?? this.formResponses,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        formValidation: formValidation ?? this.formValidation,
        params: params);
  }

  bool isNextButtonEnabled() {
    bool isValid = true;
    formResponses?.items?.forEach((element) {
      if (element.getComponentType() != DynamicFormComponentType.hidden) {}
      if (element.fieldRequired == true) {
        if (element.getComponentType() == DynamicFormComponentType.dropDown) {
          if (element.selectedDataItem == null) isValid = false;
        } else if (element.getComponentType() ==
            DynamicFormComponentType.text) {
          if (element.value == null || element.value == "") isValid = false;
        }
      }
    });

    return isValid;
  }
}
