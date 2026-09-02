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

  // No LayoutBuilder here: it forced the whole search sheet subtree to build
  // during the layout phase (any exception from it then surfaced inside
  // _RenderLayoutBuilder.performLayout), and its only product — biggestHeight —
  // was never read by MapSearchSheet.
  @override
  Widget build(BuildContext context) => MapSearchSheet(
    initialState: initialState,
    withClustering: withClustering,
    requestFocus: requestFocus,
    expansion: expansion,
  );
}
