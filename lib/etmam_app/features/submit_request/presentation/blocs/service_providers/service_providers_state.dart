part of 'service_providers_bloc.dart';

class ServiceProvidersState extends Equatable {
  final BlocStatus status;
  final int? totalPageCount;
  final int? totalItemCount;
  final int nextPageIndex;
  final List<ServiceItems>? items;
  final String? name;
  final ServiceItems? selectedItem;
  final String? subServiceId;

  final String? errorMessage;

  const ServiceProvidersState(
      {this.status = BlocStatus.initial,
      this.items,
      this.errorMessage,
      this.subServiceId,
      this.nextPageIndex = 1,
      this.totalItemCount,
      this.name,
      this.selectedItem,
      this.totalPageCount});

  ServiceProvidersState copyWith(
      {BlocStatus? status,
      int? totalPageCount,
      int? totalItemCount,
      int? nextPageIndex,
      List<ServiceItems>? items,
      ServiceItems? selectedItem,
      String? name,
      String? subServiceId,
      String? errorMessage}) {
    return ServiceProvidersState(
        status: status ?? this.status,
        totalItemCount: totalItemCount ?? this.totalItemCount,
        totalPageCount: totalPageCount ?? this.totalPageCount,
        nextPageIndex: nextPageIndex ?? this.nextPageIndex,
        items: items ?? this.items,
        selectedItem: selectedItem ?? this.selectedItem,
        subServiceId: subServiceId ?? this.subServiceId,
        errorMessage: errorMessage ?? this.errorMessage,
        name: name ?? this.name);
  }

  bool isFormValid() {
    bool isValid = false;
    items?.forEach((element) {
      if (element.isSelected ?? false) isValid = true;
    });
    return isValid;
  }

  @override
  List<Object?> get props => [status, subServiceId, name];
}
