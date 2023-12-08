part of 'bidding_type_bloc.dart';

class BiddingTypeState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final List<BiddingTypeResponse>? releationResponse;
  final BiddingTypeResponse? selectedResponse;
  final List<DropDownItem>? releationResponseDropDowns;

  const BiddingTypeState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      this.selectedResponse,
      this.releationResponseDropDowns,
      this.releationResponse});

  @override
  List<Object?> get props =>
      [status, errorMessage, releationResponse, selectedResponse];

  BiddingTypeState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      final List<BiddingTypeResponse>? releationResponse,
      final BiddingTypeResponse? selectedResponse,
      final List<DropDownItem>? releationResponseDropDowns}) {
    return BiddingTypeState(
        errorMessage: errorMessage ?? this.errorMessage,
        status: status ?? this.status,
        releationResponse: releationResponse ?? this.releationResponse,
        selectedResponse: selectedResponse ?? this.selectedResponse,
        releationResponseDropDowns:
            releationResponseDropDowns ?? this.releationResponseDropDowns);
  }
}
