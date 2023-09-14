part of 'submit_request_bloc.dart';

class SubmitRequestState extends Equatable {
  BlocStatus status;
  BlocStatus formStatus;

  List<RelationItem>? subRelations;
  String? relationId;
  String? subServiceId;
  String? subServiceName;
  String? serviceProviderId;
  String? serviceProviderName;
  String? orderId;
  bool? changeProvider;
  bool? isOTPConfirmed;
  String? errorMessage;
  CreateFormItemResponse? form;
  ValidateFormResponse? formValidation;

  SubmitRequestState(
      {this.status = BlocStatus.initial,
      this.formStatus = BlocStatus.initial,
      this.subRelations,
      this.relationId,
      this.subServiceId,
      this.subServiceName,
      this.serviceProviderId,
      this.serviceProviderName,
      this.errorMessage,
      this.changeProvider,
      this.orderId,
      this.isOTPConfirmed,
      this.form,
      this.formValidation});

  SubmitRequestState copyWith(
      {BlocStatus? status,
      List<RelationItem>? subRelations,
      String? relationId,
      String? subServiceId,
      String? subServiceName,
      String? serviceProviderId,
      String? serviceProviderName,
      String? errorMessage,
      String? orderId,
      bool? changeProvider,
      bool? isOTPConfirmed,
      CreateFormItemResponse? form,
      BlocStatus? formStatus,
      ValidateFormResponse? formValidation}) {
    return SubmitRequestState(
        status: status ?? this.status,
        subRelations: subRelations ?? this.subRelations,
        relationId: relationId ?? this.relationId,
        serviceProviderId: serviceProviderId ?? this.serviceProviderId,
        subServiceName: subServiceName ?? this.subServiceName,
        serviceProviderName: serviceProviderName ?? this.serviceProviderName,
        errorMessage: errorMessage ?? this.errorMessage,
        changeProvider: changeProvider ?? this.changeProvider,
        orderId: orderId ?? this.orderId,
        isOTPConfirmed: isOTPConfirmed ?? this.isOTPConfirmed,
        form: form ?? this.form,
        formStatus: formStatus ?? this.formStatus,
        subServiceId: subServiceId ?? this.subServiceId,
        formValidation: formValidation ?? this.formValidation);
  }

  List<subOrder>? getSubOrders() {
    List<subOrder>? list = subRelations
        ?.where((element) => ((element.isCheckedORManadatory()) &&
            element.selectedServiceProvider != null))
        .toList()
        .map((e) => subOrder(
            providerId: e.selectedServiceProvider?.id, subRelationId: e.id))
        .toList();

    if (list != null && list.isEmpty) list = null;

    return list;
  }

  List<RelationItem>? getSelectedSubOrders() {
    List<RelationItem>? list = subRelations
        ?.where((element) => ((element.isCheckedORManadatory()) &&
            element.selectedServiceProvider != null))
        .toList();

    if (list != null && list.isEmpty) list = null;

    return list;
  }

  @override
  List<Object> get props => [status, formStatus];
}
