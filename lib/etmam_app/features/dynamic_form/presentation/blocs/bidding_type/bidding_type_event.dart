part of 'bidding_type_bloc.dart';

abstract class BiddingTypeEvent extends Equatable {
  const BiddingTypeEvent();

  @override
  List<Object> get props => [];
}

class FindByRequestTypeEvent extends BiddingTypeEvent {
  const FindByRequestTypeEvent();
}

class ChangeReleationSelectionEvent extends BiddingTypeEvent {
  final BiddingTypeResponse item;
  const ChangeReleationSelectionEvent({required this.item});
}

class ChangeSubReleationSelection extends BiddingTypeEvent {
  final int index;
  final bool isSelected;
  const ChangeSubReleationSelection(
      {required this.index, required this.isSelected});
}
