import 'package:equatable/equatable.dart';

class DashboardCardEntity extends Equatable {
  final int id;
  final String name;

  const DashboardCardEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

class DashboardCards extends Equatable {
  final List<DashboardCardEntity> cards;

  const DashboardCards({
    required this.cards,
  });

  @override
  List<Object?> get props => [cards];
}
