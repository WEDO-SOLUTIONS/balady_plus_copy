part of 'home_bloc.dart';

class HomeState extends Equatable {
  final BlocStatus status;

  final BlocStatus mainServiceStatus;
  final BlocStatus topOrderedSubServiceStatus;
  final BlocStatus topRatedProvidersStatus;
  final BlocStatus adsResponseStatus;

  final MainServiceResponse? mainServiceResponse;

  final ProviderResponse? topRatedProviderResponse;
  final SubServiceResponse? topOrderedsubServiceResponse;
  final AdsResponse? adsResponse;
  final String? errorMessage;
  final bool? hideBidding;

  const HomeState(
      {this.errorMessage,
      this.status = BlocStatus.initial,
      this.mainServiceStatus = BlocStatus.initial,
      this.topOrderedSubServiceStatus = BlocStatus.initial,
      this.topRatedProvidersStatus = BlocStatus.initial,
      this.adsResponseStatus = BlocStatus.initial,
      this.mainServiceResponse,
      this.topOrderedsubServiceResponse,
      this.topRatedProviderResponse,
      this.adsResponse,
      this.hideBidding});

  HomeState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      final BlocStatus? mainServiceStatus,
      final BlocStatus? topOrderedSubServiceStatus,
      final BlocStatus? topRatedProvidersStatus,
      final BlocStatus? adsResponseStatus,
      final MainServiceResponse? mainServiceResponse,
      final ProviderResponse? topRatedProviderResponse,
      final SubServiceResponse? topOrderedsubServiceResponse,
      final AdsResponse? adsResponse,
      final bool? hideBidding}) {
    return HomeState(
        status: status ?? this.status,
        mainServiceStatus: mainServiceStatus ?? this.mainServiceStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        topOrderedSubServiceStatus:
            topOrderedSubServiceStatus ?? this.topOrderedSubServiceStatus,
        topRatedProvidersStatus:
            topRatedProvidersStatus ?? this.topRatedProvidersStatus,
        mainServiceResponse: mainServiceResponse ?? this.mainServiceResponse,
        topRatedProviderResponse:
            topRatedProviderResponse ?? this.topRatedProviderResponse,
        topOrderedsubServiceResponse:
            topOrderedsubServiceResponse ?? this.topOrderedsubServiceResponse,
        adsResponse: adsResponse ?? this.adsResponse,
        adsResponseStatus: adsResponseStatus ?? this.adsResponseStatus,
        hideBidding: hideBidding ?? this.hideBidding);
  }

  @override
  List<Object> get props => [
        status,
        mainServiceStatus,
        topOrderedSubServiceStatus,
        topRatedProvidersStatus,
        adsResponseStatus
      ];

  bool get isLoading =>
      status == BlocStatus.loading ||
      mainServiceStatus == BlocStatus.loading ||
      topOrderedSubServiceStatus == BlocStatus.loading ||
      topRatedProvidersStatus == BlocStatus.loading ||
      adsResponseStatus == BlocStatus.loading;

  int? getTopOrderedSubServiceCount() {
    return topOrderedsubServiceResponse?.items?.length;
  }
}
