part of 'branch_map_bloc.dart';

abstract class BranchMapEvent extends Equatable {
  const BranchMapEvent();

  @override
  List<Object> get props => [];
}

class SelectBranchEvent extends BranchMapEvent {
  final String id;
  const SelectBranchEvent({required this.id});

  @override
  List<Object> get props => [];
}
