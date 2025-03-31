import 'package:mapness/entities/saudi_pass/offers_group.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';

extension OffersGroupMapper on OffersGroup {
  static OffersGroup fromCategoryIds(List<String> categoryIds) {
    const fallbackGroup = OffersGroup.services;

    final mainCategory = categoryIds.firstOrNull;
    if (mainCategory == null) {
      return fallbackGroup;
    }

    return switch (mainCategory) {
      Category.food => OffersGroup.food,
      Category.shopping => OffersGroup.shopping,
      Category.homeAndAuto => OffersGroup.homeAndAuto,
      Category.beautyAndHealth => OffersGroup.beautyAndHealth,
      Category.entertainment => OffersGroup.entertainment,
      Category.services => OffersGroup.services,
      _ => fallbackGroup,
    };
  }

  String toCategoryId() => switch (this) {
        OffersGroup.food => Category.food,
        OffersGroup.shopping => Category.shopping,
        OffersGroup.homeAndAuto => Category.homeAndAuto,
        OffersGroup.beautyAndHealth => Category.beautyAndHealth,
        OffersGroup.entertainment => Category.entertainment,
        OffersGroup.services => Category.services,
      };
}
