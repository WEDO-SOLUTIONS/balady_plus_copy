part of 'permits_bloc.dart';

class PermitsState extends Equatable {
  final BlocStatus permitsStatus;
  final List<PermitItem>? permits;
  final String? errorMessage;
  final BlocStatus status;

  const PermitsState(
      {this.permitsStatus = BlocStatus.initial,
      this.status = BlocStatus.initial,
      this.permits,
      this.errorMessage});

  @override
  List<Object?> get props => [permitsStatus, permits, errorMessage, status];

  PermitsState copyWith(
      {BlocStatus? permitsStatus,
      List<PermitItem>? permits,
      String? errorMessage,
      ActivityDetailsPageParams? args,
      BlocStatus? status}) {
    return PermitsState(
        permitsStatus: permitsStatus ?? this.permitsStatus,
        permits: permits ?? this.permits,
        errorMessage: errorMessage,
        status: status ?? this.status);
  }

  Map<String, List<PermitItem>> getPermits() {
    Map<String, List<PermitItem>> permitsLists = {};

    permits?.forEach((e) {
      if (permitsLists.containsKey(e.detailedActivityId.toString())) {
        permitsLists[e.detailedActivityId.toString()]!.add(e);
      } else {
        permitsLists[e.detailedActivityId!.toString()] = [];
        permitsLists[e.detailedActivityId.toString()]!.add(e);
      }
    });

    return permitsLists;
  }

  @override
  String toString() {
    return 'AddetionalActivityState(PermitItem: $PermitItem, permitsStatus: $permitsStatus, errorMessage: $errorMessage)';
  }
}
