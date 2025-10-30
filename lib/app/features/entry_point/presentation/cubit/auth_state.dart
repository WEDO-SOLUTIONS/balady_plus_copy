part of 'auth_cubit.dart';

class EntryPointState extends Equatable {
  final BlocStatus gisStatus;
  final AuthStatus status;
  final SSOToken? token;
  final ApigeeTokenResponse? apigeeToken;
  final SsoUserInfo? userInfo;
  final DelegatorEntity? selectedDelegator;
  final AgentEntity? selectedAgent;
  final bool showSplash;

  final String? cityId;
  final String? cityName;
  final String? errorMessage;
  final BlocStatus blocStatus;
  final GISParams? userLocation;
  final GISResponse? userLocationGIS;

  const EntryPointState({
    this.status = AuthStatus.initial,
    this.blocStatus = BlocStatus.initial,
    this.gisStatus = BlocStatus.initial,
    this.token,
    this.apigeeToken,
    this.cityId,
    this.cityName,
    this.errorMessage,
    this.userInfo,
    this.selectedDelegator,
    this.selectedAgent,
    this.userLocation,
    this.userLocationGIS,
    this.showSplash = true,
  });

  EntryPointState copyWith({
    AuthStatus? status,
    BlocStatus? blocStatus,
    SSOToken? token,
    ApigeeTokenResponse? apigeeToken,
    BlocStatus? gisStatus,
    String? errorMessage,
    final String? cityId,
    final String? cityName,
    SsoUserInfo? userInfo,
    Nullable<DelegatorEntity?>? selectedDelegator,
    Nullable<AgentEntity?>? selectedAgent,
    GISParams? userLocation,
    GISResponse? userLocationGIS,
    bool? showSplash,
  }) {
    return EntryPointState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      token: token ?? this.token,
      cityId: cityId ?? this.cityId,
      cityName: cityName ?? this.cityName,
      userInfo: userInfo ?? this.userInfo,
      blocStatus: blocStatus ?? this.blocStatus,
      apigeeToken: apigeeToken ?? this.apigeeToken,
      selectedDelegator: selectedDelegator == null ? this.selectedDelegator : selectedDelegator.value,
      selectedAgent: selectedAgent == null ? this.selectedAgent : selectedAgent.value,
      userLocation: userLocation ?? this.userLocation,
      userLocationGIS: userLocationGIS ?? this.userLocationGIS,
      gisStatus: gisStatus ?? this.gisStatus,
      showSplash: showSplash ?? this.showSplash,
    );
  }

  String getSearchText() => CommonProperties.userLocationGIS != null &&
          CommonProperties.userLocationGIS!.cityName != null &&
          CommonProperties.userLocationGIS!.cityName!.isNotEmpty
      ? 'ابحث في ${CommonProperties.userLocationGIS!.cityName!} عن...'
      : 'ابحث عن...';

  @override
  List<Object?> get props => [
        status,
        userInfo,
        token,
        cityId,
        blocStatus,
        apigeeToken,
        selectedDelegator,
        selectedAgent,
        userLocation,
        userLocationGIS,
        gisStatus,
        showSplash
      ];

  @override
  String toString() => 'AuthState(status: $status, errorMessage: $errorMessage)';
}
