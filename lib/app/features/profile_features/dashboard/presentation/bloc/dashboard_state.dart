part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final BlocRequestStatus status;
  final List<DashboardCardEntity> cards;
  final Map<DashboardCardEntity, CardState> cardsStates;
  final String? errorMessage;

  const DashboardState({
    this.status = BlocRequestStatus.initial,
    this.cards = const [],
    this.cardsStates = const {},
    this.errorMessage,
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
  }) {
    return DashboardState(
      status: status ?? this.status,
      cards: cards ?? this.cards,
      cardsStates: cardsStates ?? this.cardsStates,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        cards,
        cardsStates,
        errorMessage,
      ];

  int totalCount() {
    int totalCount = 0;
    cardsStates.entries.forEach((element) {
      totalCount += (element.value.totalCount ?? 0);
    });
    return totalCount;
  }

  bool allCardsSuccess() {
    bool status = true;
    cardsStates.entries.forEach((element) {
      if (element.value.statisticsStatuses ==
          BlocRequestStatus.submissionGetFailure) status = false;
    });
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
    Nullable<DashboardProductEntity?>? selectedProduct,
    BlocRequestStatus? statisticsStatuses,
    List<DashboardStatisticsEntity>? statistics,
  }) {
    return CardState(
      productsStatus: productsStatus ?? this.productsStatus,
      products: products ?? this.products,
      selectedProduct: selectedProduct == null
          ? this.selectedProduct
          : selectedProduct.value,
      statisticsStatuses: statisticsStatuses ?? this.statisticsStatuses,
      statistics: statistics ?? this.statistics,
    );
  }

  @override
  List<Object?> get props => [
        productsStatus,
        products,
        selectedProduct,
        statisticsStatuses,
        statistics,
      ];

  int get totalCount => (statistics ?? []).map((e) => e.count).fold(0,
      (previousValue, currentValue) => (previousValue + currentValue).toInt());
}
