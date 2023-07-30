part of 'branch_map_bloc.dart';

class BranchMapState extends Equatable {
  BlocStatus status;
  Branch? selectedBranch;
  String? errorMessage;
  BranchMapState(
      {this.status = BlocStatus.initial,
      this.selectedBranch,
      this.errorMessage});

  BranchMapState copyWith(
      {BlocStatus? status, Branch? selectedBranch, String? errorMessage}) {
    return BranchMapState(
        selectedBranch: selectedBranch ?? this.selectedBranch,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object> get props => [
        status,
      ];
}
