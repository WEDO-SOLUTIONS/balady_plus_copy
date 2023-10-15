part of 'cr_step4_shop_data_cubit.dart';

class CrStep4ShopDataState extends Equatable {
  final BlocStatus accommodationTypesStatus;

  final List<CrLookupsEntity> accommodationTypes;
  final DropDownItem? selectedAccommodationType;
  final String errorMessage;
  final List<CommercialBoardType>? selectedBoards;
  final List<DropDownItem>? boards;
  const CrStep4ShopDataState(
      {this.accommodationTypesStatus = BlocStatus.initial,
      this.selectedAccommodationType,
      this.accommodationTypes = const [],
      this.errorMessage = '',
      this.selectedBoards,
      this.boards});

  @override
  List<Object?> get props => [
        accommodationTypesStatus,
        accommodationTypes,
        selectedAccommodationType,
        errorMessage,
        selectedBoards
      ];

  CrStep4ShopDataState copyWith(
      {BlocStatus? accommodationTypesStatus,
      List<CrLookupsEntity>? accommodationTypes,
      DropDownItem? selectedAccommodationType,
      String? errorMessage,
      List<CommercialBoardType>? selectedBoards,
      List<DropDownItem>? boards}) {
    return CrStep4ShopDataState(
        accommodationTypesStatus:
            accommodationTypesStatus ?? this.accommodationTypesStatus,
        accommodationTypes: accommodationTypes ?? this.accommodationTypes,
        selectedAccommodationType:
            selectedAccommodationType ?? this.selectedAccommodationType,
        errorMessage: errorMessage ?? this.errorMessage,
        selectedBoards: selectedBoards ?? this.selectedBoards,
        boards: boards ?? this.boards);
  }
}
