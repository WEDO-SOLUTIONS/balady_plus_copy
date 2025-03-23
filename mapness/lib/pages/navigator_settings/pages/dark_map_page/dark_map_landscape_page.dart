import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/pages/navigator_settings/pages/dark_map_page/dark_map_page_content.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/path_nav/ui/landscape/base_landscape_bottom_sheet.dart';

@RoutePage()
class DarkMapLandscapePage extends StatelessWidget {
  const DarkMapLandscapePage({super.key});

  @override
  Widget build(BuildContext context) => BaseLandscapeBottomSheet(
        content: [
          BaladyTopBar.iconAndText(
            title: context.l10n.darkMap,
            colorEnabled: context.colorsV3.accentDefault,
            trailing: ActionModel(
              text: context.l10n.feedbackBreaksSheetClose,
              onPressed: context.router.popForced,
            ),
          ),
          const DarkMapPageContent(),
        ],
      );
}
