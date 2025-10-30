part of 'renew_commercial_license_bloc.dart';

class RenewStartServiceState extends Equatable {
  final BlocStatus status;
  final int? licenseId;
  final String? errorMessage;

  const RenewStartServiceState(
      {this.status = BlocStatus.initial, this.licenseId, this.errorMessage});

  @override
  List<Object?> get props => [status, licenseId, errorMessage];

  RenewStartServiceState copyWith(
      {BlocStatus? status, int? licenseId, String? errorMessage}) {
    return RenewStartServiceState(
        status: status ?? this.status,
        licenseId: licenseId ?? this.licenseId,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}
