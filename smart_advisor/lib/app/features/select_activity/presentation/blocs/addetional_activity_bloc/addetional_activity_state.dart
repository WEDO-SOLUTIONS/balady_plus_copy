part of 'addetional_activity_bloc.dart';

class AddetionalActivityState extends Equatable {
  final BlocStatus addetionalActivitesStatus;
  final BlocStatus status;

  final List<AddetionalActivityItem>? addetionalActivitesResponse;
  final String? errorMessage;

  const AddetionalActivityState({
    this.addetionalActivitesStatus = BlocStatus.initial,
    this.status = BlocStatus.initial,
    this.addetionalActivitesResponse,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        addetionalActivitesStatus,
        addetionalActivitesResponse,
        errorMessage,
        status
      ];

  AddetionalActivityState copyWith(
      {BlocStatus? addetionalActivitesStatus,
      List<AddetionalActivityItem>? addetionalActivitesResponse,
      String? errorMessage,
      BlocStatus? status}) {
    return AddetionalActivityState(
      addetionalActivitesStatus:
          addetionalActivitesStatus ?? this.addetionalActivitesStatus,
      addetionalActivitesResponse:
          addetionalActivitesResponse ?? this.addetionalActivitesResponse,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  String toString() {
    return 'AddetionalActivityState(addetionalActivitesResponse: $addetionalActivitesResponse, addetionalActivitesStatus: $addetionalActivitesStatus, errorMessage: $errorMessage)';
  }
}
