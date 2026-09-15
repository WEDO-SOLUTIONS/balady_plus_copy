import 'package:flutter/widgets.dart';

import 'package:mapness/widgets/landing/dashboard_contents/base_dashboard_content.dart';
import 'package:mapness/widgets/landing/dashboard_contents/dashboard_theme_config.dart';
import 'package:sheetify/multi_state_sheet/multi_state_sheet.dart';
import 'package:sheetify/multi_state_sheet/state_snapping/sheet_state_mapper.dart';

class NationalDayDashboardContent extends StatelessWidget {
  final DashboardThemeConfig themeConfig;
  final MultiStateSheetController<ThreeStateSheet> bottomSheetController;
  final AnimationController fireworksController;

  const NationalDayDashboardContent({
    required this.themeConfig,
    required this.bottomSheetController,
    required this.fireworksController,
    super.key,
  });

  // Поведение сейчас такое же, как у BaseDashboardContent, но вынесено
  // в отдельный виджет под тему. Если для National Day понадобится другая
  // верстка, её можно будет поменять только здесь.
  @override
  Widget build(BuildContext context) => BaseDashboardContent(
    themeConfig: themeConfig,
    bottomSheetController: bottomSheetController,
    fireworksController: fireworksController,
  );
}
