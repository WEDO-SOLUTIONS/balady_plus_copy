part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final BlocRequestStatus status;
  final List<DashboardCardEntity> cards;
  final Map<DashboardCardEntity, CardState> cardsStates;
  final String? errorMessage;
  final DelegatorsCubit? delegatorsCubit;

  const DashboardState({
    this.status = BlocRequestStatus.initial,
    this.cards = const [],
    this.cardsStates = const {},
    this.errorMessage,
    this.delegatorsCubit,
  });

  String get error => errorMessage ?? '';

  bool get showNoData {
    List<bool> showNoData = [];
    for (var item in cardsStates.values) {
      if (item.totalCount != 0) showNoData.add(false);
      if (!item.productsStatus.isSubmissionGetSuccess) showNoData.add(false);

      showNoData.add(true);
    }
    return showNoData.contains(true);
  }

  DashboardState copyWith({
    BlocRequestStatus? status,
    List<DashboardCardEntity>? cards,
    Map<DashboardCardEntity, CardState>? cardsStates,
    String? errorMessage,
    VolunteeringStatisticsEntity? volunteeringStatistics,
    DelegatorsCubit? delegatorsCubit,
  }) {
    return DashboardState(
      status: status ?? this.status,
      cards: cards ?? this.cards,
      cardsStates: cardsStates ?? this.cardsStates,
      errorMessage: errorMessage ?? this.errorMessage,
      delegatorsCubit: delegatorsCubit ?? this.delegatorsCubit,
    );
  }

  @override
  List<Object?> get props => [status, cards, cardsStates, errorMessage, delegatorsCubit];

  int totalCount() {
    int totalCount = 0;
    for (var element in cardsStates.entries) {
      totalCount += (element.value.totalCount);
    }
    return totalCount;
  }

  bool allCardsSuccess() {
    bool status = true;
    for (var element in cardsStates.entries) {
      if (element.value.statisticsStatuses == BlocRequestStatus.submissionGetFailure) status = false;
    }
    return status;
  }
}

class CardState extends Equatable {
  final BlocRequestStatus productsStatus;
  final List<DashboardProductEntity> products;
  final DashboardProductEntity? selectedProduct;
  final BlocRequestStatus statisticsStatuses;
  final List<DashboardStatisticsEntity>? statistics;

  const CardState({
    this.productsStatus = BlocRequestStatus.initial,
    this.products = const [],
    this.selectedProduct,
    this.statisticsStatuses = BlocRequestStatus.submissionGetLoading,
    this.statistics,
  });

  CardState copyWith({
    BlocRequestStatus? productsStatus,
    List<DashboardProductEntity>? products,
    DashboardProductEntity? selectedProduct,
    BlocRequestStatus? statisticsStatuses,
    List<DashboardStatisticsEntity>? statistics,
  }) {
    return CardState(
      productsStatus: productsStatus ?? this.productsStatus,
      products: products ?? this.products,
      selectedProduct: selectedProduct == null ? this.selectedProduct : selectedProduct,
      statisticsStatuses: statisticsStatuses ?? this.statisticsStatuses,
      statistics: statistics ?? this.statistics,
    );
  }

  @override
  List<Object?> get props => [productsStatus, products, selectedProduct, statisticsStatuses, statistics];

  int get totalCount => (statistics ?? [])
      .map((e) => e.count)
      .fold(0, (previousValue, currentValue) => (previousValue + currentValue).toInt());
}

class LoadingVolunteeringStatisticsState extends DashboardState {}

class SuccessVolunteeringStatisticsState extends DashboardState {
  final VolunteeringStatisticsEntity? volunteeringStatistics;

  const SuccessVolunteeringStatisticsState({required this.volunteeringStatistics});

  @override
  List<Object?> get props => [volunteeringStatistics];
}
