part of 'auth_cubit.dart';

class EntryPointState extends Equatable {
  final AuthStatus status;
  final SSOToken? token;
  final ApigeeTokenResponse? apigeeToken;
  final SsoUserInfo? userInfo;
  final DelegatorEntity? selectedDelegator;
  final String? cityId;
  final String? cityName;
  final String? errorMessage;
  final BlocStatus blocStatus;

  const EntryPointState({
    this.status = AuthStatus.initial,
    this.blocStatus = BlocStatus.initial,
    this.token,
    this.apigeeToken,
    this.cityId,
    this.cityName,
    this.errorMessage,
    this.userInfo,
    this.selectedDelegator,
  });

  EntryPointState copyWith({
    AuthStatus? status,
    BlocStatus? blocStatus,
    SSOToken? token,
    ApigeeTokenResponse? apigeeToken,
    String? errorMessage,
    final String? cityId,
    final String? cityName,
    SsoUserInfo? userInfo,
    Nullable<DelegatorEntity?>? selectedDelegator,
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
      selectedDelegator: selectedDelegator == null
          ? this.selectedDelegator
          : selectedDelegator.value,
    );
  }

  @override
  List<Object?> get props => [
        status,
        token,
        cityId,
        blocStatus,
        apigeeToken,
      ];

  @override
  String toString() =>
      'AuthState(status: $status, errorMessage: $errorMessage)';
}
