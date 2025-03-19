import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mapness/pages/navi_search/navi_bottom_sheet.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';

@RoutePage()
class NaviSearchPage extends StatelessWidget {
  final bool withClustering;
  final bool requestFocus;
  final Expansion? expansion;

  const NaviSearchPage({
    this.withClustering = false,
    this.requestFocus = true,
    this.expansion,
    super.key,
  });

  @override
  Widget build(BuildContext context) => const NaviBottomSheet();
}
