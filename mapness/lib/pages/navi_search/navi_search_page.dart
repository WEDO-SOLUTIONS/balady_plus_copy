import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mapness/pages/navi_search/navi_bottom_sheet.dart';

@RoutePage()
class NaviSearchPage extends StatelessWidget {
  final bool isPathNavScreen;

  const NaviSearchPage({
    this.isPathNavScreen = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) => NaviBottomSheet(isPathNavScreen: isPathNavScreen);
}
