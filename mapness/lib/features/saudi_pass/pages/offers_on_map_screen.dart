import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart' as lookups_body;
import 'package:mapness/features/saudi_pass/widgets/offers_on_map_widget.dart';

@RoutePage()
class OffersOnMapPage extends StatelessWidget {
  /// City ids from the originating list (`OffersMapContext.cityIds`). The
  /// Map must use exactly this set — BRD US-03 BR-02.
  final Set<String> cityIds;

  /// Display label for the city portion of the Map top bar.
  final String cityTitle;
  final Set<lookups_body.Category> categories;
  final Set<lookups_body.SubCategory> subCategories;
  final Set<lookups_body.RecommendedType> recommendedTypes;

  const OffersOnMapPage({
    required this.cityIds,
    required this.cityTitle,
    super.key,
    this.categories = const {},
    this.subCategories = const {},
    this.recommendedTypes = const {},
  });

  @override
  Widget build(BuildContext context) => OffersOnMapWidget(
        cityIds: cityIds,
        cityTitle: cityTitle,
        categories: categories,
        subCategories: subCategories,
        recommendedTypes: recommendedTypes,
      );
}
