import 'package:equatable/equatable.dart';

class DashboardProductsParamsModel extends Equatable {
  final int cardId;

  const DashboardProductsParamsModel({
    required this.cardId,
  });

  Map<String, dynamic> toMap() {
    return {
      'cardId': cardId,
    };
  }

  @override
  List<Object?> get props => [cardId];
}
