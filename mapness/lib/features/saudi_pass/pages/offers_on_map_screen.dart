import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart' as lookups_body;
import 'package:mapness/features/saudi_pass/widgets/offers_on_map_widget.dart';

@RoutePage()
class OffersOnMapPage extends StatelessWidget {
  final Set<lookups_body.Category> categories;
  final Set<lookups_body.RecommendedType> recommendedTypes;

  const OffersOnMapPage({
    super.key,
    this.categories = const {},
    this.recommendedTypes = const {},
  });

  @override
  Widget build(BuildContext context) => OffersOnMapWidget(
        categories: categories,
        recommendedTypes: recommendedTypes,
      );
}
