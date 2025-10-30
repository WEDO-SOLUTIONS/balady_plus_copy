part of 'etmam_entry_point_cubit.dart';

class EtmamEntryPointState extends Equatable {
  final Profile? profile;
  final String? cityId;
  final String? cityName;
  final String? errorMessage;
  final BlocStatus blocStatus;

  const EtmamEntryPointState(
      {this.blocStatus = BlocStatus.initial,
      this.cityId,
      this.cityName,
      this.errorMessage,
      this.profile});

  @override
  List<Object?> get props => [profile, cityId, blocStatus];

  EtmamEntryPointState copyWith(
      {BlocStatus? blocStatus,
      String? errorMessage,
      final String? cityId,
      final String? cityName,
      Profile? profile}) {
    return EtmamEntryPointState(
        errorMessage: errorMessage ?? this.errorMessage,
        cityId: cityId ?? this.cityId,
        cityName: cityName ?? this.cityName,
        profile: profile ?? this.profile,
        blocStatus: blocStatus ?? this.blocStatus);
  }

  @override
  String toString() =>
      'AuthState(status: $blocStatus, errorMessage: $errorMessage)';
}
