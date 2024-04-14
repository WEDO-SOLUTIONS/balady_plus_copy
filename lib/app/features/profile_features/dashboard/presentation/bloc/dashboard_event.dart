part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class DashboardEventInitial extends DashboardEvent {}

class DashboardLoadStatistics extends DashboardEvent {}

class DashboardLoadCardStatistics extends DashboardEvent {
  final DashboardCardEntity card;
  final DashboardProductEntity? product;

  const DashboardLoadCardStatistics({
    required this.card,
    this.product,
  });

  @override
  List<Object?> get props => [card, product];
}

class DashboardOnProductsPressed extends DashboardEvent {
  final DashboardCardEntity card;

  const DashboardOnProductsPressed({required this.card});

  @override
  List<Object> get props => [card];
}

class DashboardOnProductSelected extends DashboardEvent {
  final DashboardCardEntity card;
  final DashboardProductEntity? product;

  const DashboardOnProductSelected({
    required this.card,
    required this.product,
  });

  @override
  List<Object?> get props => [card, product];
}

class DashboardRetry extends DashboardEvent {}
