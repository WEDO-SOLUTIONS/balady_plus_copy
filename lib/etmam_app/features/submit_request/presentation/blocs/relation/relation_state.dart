part of 'relation_bloc.dart';

class RelationState extends Equatable {
  BlocStatus status;
  RelationResponse? relationRespone;
  List<RelationItem>? subRelations;
  String? subServiceId;
  String? subServiceName;
  String? serviceProviderId;
  String? serviceProviderName;
  String? errorMessage;
  RelationState(
      {this.status = BlocStatus.initial,
      this.relationRespone,
      this.subRelations,
      this.subServiceId,
      this.subServiceName,
      this.serviceProviderId,
      this.serviceProviderName,
      this.errorMessage});

  RelationState copyWith(
      {BlocStatus? status,
      RelationResponse? relationRespone,
      List<RelationItem>? subRelations,
      String? subServiceId,
      String? subServiceName,
      String? serviceProviderId,
      String? serviceProviderName,
      String? errorMessage}) {
    return RelationState(
        status: status ?? this.status,
        relationRespone: relationRespone ?? this.relationRespone,
        subRelations: subRelations ?? this.subRelations,
        serviceProviderId: serviceProviderId ?? this.serviceProviderId,
        subServiceName: subServiceName ?? this.subServiceName,
        serviceProviderName: serviceProviderName ?? this.serviceProviderName,
        subServiceId: subServiceId ?? this.subServiceId,
        errorMessage: errorMessage ?? this.errorMessage);
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

  bool isValidToSubmit() {
    bool isValid = true;
    subRelations?.forEach((element) {
      if (element.isCheckedORManadatory() &&
          element.selectedServiceProvider == null) isValid = false;
    });

    return isValid;
  }

  @override
  List<Object> get props => [status];
}
