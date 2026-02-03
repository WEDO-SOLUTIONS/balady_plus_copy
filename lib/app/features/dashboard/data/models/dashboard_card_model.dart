
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_card_entity.dart';

class DashboardCardModel extends DashboardCardEntity {
  const DashboardCardModel({
    required super.id,
    required super.name,
  });

  factory DashboardCardModel.fromMap(Map<String, dynamic> json) {
    return DashboardCardModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class DashboardCardsModel extends DashboardCards {
  const DashboardCardsModel({
    required super.cards,
  });

  factory DashboardCardsModel.fromList(List<dynamic> list) => DashboardCardsModel(
        cards: list.map((e) => DashboardCardModel.fromMap(e as Map<String, dynamic>)).toList(),
      );
}
