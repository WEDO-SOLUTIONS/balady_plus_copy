import 'package:flutter/widgets.dart';
import 'package:sheetify/sheetify.dart';

import 'package:mapness/widgets/landing/dashboard_contents/base_dashboard_content.dart';
import 'package:mapness/widgets/landing/dashboard_contents/dashboard_theme_config.dart';

class NationalDayDashboardContent extends StatelessWidget {
  const NationalDayDashboardContent({
    required this.themeConfig,
    required this.bottomSheetController,
    super.key,
  });

  final DashboardThemeConfig themeConfig;
  final MultiStateSheetController<ThreeStateSheet> bottomSheetController;

  @override
  Widget build(BuildContext context) {
    // Поведение сейчас такое же, как у BaseDashboardContent, но вынесено
    // в отдельный виджет под тему. Если для National Day понадобится другая
    // верстка, её можно будет поменять только здесь.
    return BaseDashboardContent(
      themeConfig: themeConfig,
      bottomSheetController: bottomSheetController,
    );
  }
}
