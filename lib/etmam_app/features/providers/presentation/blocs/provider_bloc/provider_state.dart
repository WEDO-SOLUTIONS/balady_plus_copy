part of 'provider_bloc.dart';

class ProviderState extends Equatable {
  BlocStatus status;
  int? totalPageCount;
  int? totalItemCount;
  int nextPageIndex;
  String? name;
  List<ProviderItem>? items;
  String? subServiceId;
  String? errorMessage;

  ProviderState(
      {this.status = BlocStatus.initial,
      this.totalItemCount,
      this.totalPageCount,
      this.nextPageIndex = 1,
      this.items,
      this.name,
      this.subServiceId,
      this.errorMessage});

  ProviderState copyWith(
      {BlocStatus? status,
      int? totalPageCount,
      int? totalItemCount,
      int? nextPageIndex,
      List<ProviderItem>? items,
      String? name,
      String? subServiceId,
      String? errorMessage}) {
    return ProviderState(
        status: status ?? this.status,
        totalItemCount: totalItemCount ?? this.totalItemCount,
        totalPageCount: totalPageCount ?? this.totalPageCount,
        nextPageIndex: nextPageIndex ?? this.nextPageIndex,
        items: items ?? this.items,
        subServiceId: subServiceId ?? this.subServiceId,
        name: name ?? this.name,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object?> get props => [status, name];
}
