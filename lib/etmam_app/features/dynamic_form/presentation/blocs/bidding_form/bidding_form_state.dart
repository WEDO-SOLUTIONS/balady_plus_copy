part of 'bidding_form_bloc.dart';

class BiddingFormState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final List<CreateFormItemResponse>? formResponses;
  final BiddingFormParams? params;
  final int currentPageValue;
  final ValidateFormResponse? formValidation;
  final UploadBidAttachmentResponse? uploadBidAttachmentResponse;
  final String? attachmentPath;
  final String? attachmentName;

  const BiddingFormState(
      {this.status = BlocStatus.initial,
      this.currentPageValue = 0,
      this.params,
      this.errorMessage,
      this.formResponses,
      this.formValidation,
      this.uploadBidAttachmentResponse,
      this.attachmentPath,
      this.attachmentName});

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        currentPageValue,
        params,
        formValidation,
        uploadBidAttachmentResponse,
        attachmentPath,
        attachmentName
      ];

  BiddingFormState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      final List<CreateFormItemResponse>? formResponses,
      final String? currentFormId,
      final int? currentPageValue,
      final BiddingFormParams? params,
      final ValidateFormResponse? formValidation,
      final Nullable<UploadBidAttachmentResponse?>? uploadBidAttachmentResponse,
      final Nullable<String?>? attachmentPath,
      final Nullable<String?>? attachmentName}) {
    return BiddingFormState(
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      formResponses: formResponses ?? this.formResponses,
      currentPageValue: currentPageValue ?? this.currentPageValue,
      params: params ?? this.params,
      formValidation: formValidation ?? this.formValidation,
      uploadBidAttachmentResponse: uploadBidAttachmentResponse == null
          ? this.uploadBidAttachmentResponse
          : uploadBidAttachmentResponse.value,
      attachmentPath:
          attachmentPath == null ? this.attachmentPath : attachmentPath.value,
      attachmentName:
          attachmentName == null ? this.attachmentName : attachmentName.value,
    );
  }

  int get formsCount => formResponses?.length ?? 0;

  CreateFormItemResponse? get currentForm => formResponses?[currentPageValue];
  List<String>? get getServicesIds {
    List<String> list = [];
    print(params?.relation.inputsRequired);
    if (params!.relation.inputsRequired == true)
      list.add(params!.relation.service!.id!);

    params!.relation.subRelations?.forEach((element) {
      if (element.inputsRequired == true) {
        list.add(element.service!.id!);
      }
    });

    return list;
  }

  bool isNextButtonEnabled() {
    bool isValid = true;
    formResponses?.firstOrNull?.items?.forEach((element) {
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
