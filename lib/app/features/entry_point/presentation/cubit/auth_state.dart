part of 'auth_cubit.dart';

class EntryPointState extends Equatable {
  final BlocStatus gisStatus;
  final AuthStatus status;
  final SSOToken? token;
  final ApigeeTokenResponse? apigeeToken;
  final SsoUserInfo? userInfo;
  final DelegatorEntity? selectedDelegator;
  final String? cityId;
  final String? cityName;
  final String? errorMessage;
  final BlocStatus blocStatus;
  final GISParams? userLocation;
  final GISResponse? userLocationGIS;

  const EntryPointState(
      {this.status = AuthStatus.initial,
      this.blocStatus = BlocStatus.initial,
      this.gisStatus = BlocStatus.initial,
      this.token,
      this.apigeeToken,
      this.cityId,
      this.cityName,
      this.errorMessage,
      this.userInfo,
      this.selectedDelegator,
      this.userLocation,
      this.userLocationGIS});

  EntryPointState copyWith(
      {AuthStatus? status,
      BlocStatus? blocStatus,
      SSOToken? token,
      ApigeeTokenResponse? apigeeToken,
      BlocStatus? gisStatus,
      String? errorMessage,
      final String? cityId,
      final String? cityName,
      SsoUserInfo? userInfo,
      Nullable<DelegatorEntity?>? selectedDelegator,
      GISParams? userLocation,
      GISResponse? userLocationGIS}) {
    return EntryPointState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        token: token ?? this.token,
        cityId: cityId ?? this.cityId,
        cityName: cityName ?? this.cityName,
        userInfo: userInfo ?? this.userInfo,
        blocStatus: blocStatus ?? this.blocStatus,
        apigeeToken: apigeeToken ?? this.apigeeToken,
        selectedDelegator: selectedDelegator == null
            ? this.selectedDelegator
            : selectedDelegator.value,
        userLocation: userLocation ?? this.userLocation,
        userLocationGIS: userLocationGIS ?? this.userLocationGIS,
        gisStatus: gisStatus ?? this.gisStatus);
  }

  String getSearchText() => CommonProperties.userLocationGIS != null &&
          CommonProperties.userLocationGIS!.cityName != null &&
          CommonProperties.userLocationGIS!.cityName!.isNotEmpty
      ? 'ابحث في ${CommonProperties.userLocationGIS!.cityName!} عن...'
      : 'ابحث عن...';

  @override
  List<Object?> get props => [
        status,
        token,
        cityId,
        blocStatus,
        apigeeToken,
        selectedDelegator,
        userLocation,
        userLocationGIS,
        gisStatus
      ];

  @override
  String toString() =>
      'AuthState(status: $status, errorMessage: $errorMessage)';
}
