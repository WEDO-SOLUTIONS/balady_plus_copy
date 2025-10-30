// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'zmzm_bloc.dart';

class ZmZmState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final int currentPageValue;
  final List<String>? cities;
  final String? selectedCity;
  final List<ZMZMItemModel>? items;

  ZmZmState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      this.currentPageValue = 0,
      this.cities,
      this.selectedCity,
      this.items});
  @override
  List<Object?> get props =>
      [status, currentPageValue, cities, items, selectedCity, errorMessage];

  ZmZmState copyWith(
      {BlocStatus? status,
      String? errorMessage,
      int? currentPageValue,
      List<String>? cities,
      String? selectedCity,
      List<ZMZMItemModel>? items}) {
    return ZmZmState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        cities: cities ?? this.cities,
        selectedCity: selectedCity ?? this.selectedCity,
        items: items ?? this.items);
  }

  List<ZMZMItemModel> get selectedItems => selectedCity != null
      ? (items ?? []).where((element) => element.city == selectedCity).toList()
      : [];
}
