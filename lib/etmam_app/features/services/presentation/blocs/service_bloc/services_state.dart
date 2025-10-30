part of 'services_bloc.dart';

class ServicesState extends Equatable {
  BlocStatus status;
  int? totalPageCount;
  int? totalItemCount;
  int nextPageIndex;
  List<ServiceItems>? items;
  String? name;
  String? subServiceId;
  String? subServiceName;
  String? errorMessage;

  ServicesState(
      {this.status = BlocStatus.initial,
      this.totalItemCount,
      this.totalPageCount,
      this.nextPageIndex = 1,
      this.items,
      this.name,
      this.subServiceId,
      this.subServiceName,
      this.errorMessage});

  ServicesState copyWith(
      {BlocStatus? status,
      int? totalPageCount,
      int? totalItemCount,
      int? nextPageIndex,
      List<ServiceItems>? items,
      String? name,
      String? subServiceId,
      String? subServiceName,
      String? errorMessage}) {
    return ServicesState(
        status: status ?? this.status,
        totalItemCount: totalItemCount ?? this.totalItemCount,
        totalPageCount: totalPageCount ?? this.totalPageCount,
        nextPageIndex: nextPageIndex ?? this.nextPageIndex,
        items: items ?? this.items,
        name: name ?? this.name,
        subServiceId: subServiceId ?? this.subServiceId,
        subServiceName: subServiceName ?? this.subServiceName,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object?> get props => [status, name];
}
