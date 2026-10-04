import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mapness/pages/map_search/map_search_sheet.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';

@RoutePage()
class SearchPage extends StatelessWidget {
  final bool withClustering;
  final bool requestFocus;
  final Expansion? expansion;
  final String? initialState;

  const SearchPage({
    this.withClustering = false,
    this.requestFocus = true,
    this.expansion,
    super.key,
    this.initialState,
  });

  @override
  Widget build(BuildContext context) => MapSearchSheet(
    initialState: initialState,
    withClustering: withClustering,
    requestFocus: requestFocus,
    expansion: expansion,
  );
}
