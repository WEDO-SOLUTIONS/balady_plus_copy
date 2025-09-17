import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class AddPlaceItem extends StatelessWidget {
  final VoidCallback onTapMetrics;
  final VoidCallback? googleSearchOnTap;

  const AddPlaceItem({
    required this.onTapMetrics,
    this.googleSearchOnTap,
    super.key,
  });

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: Spacing.$3x),
        Text(
          context.l10n.searchDidntFind,
          style: context.textStyles.bodyLargeSemiBold,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Spacing.$1x),
        Text(
          context.l10n.searchAddAnObjectOrCompanyToTheMap,
          style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Spacing.$3x),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: uikit.AppButton(
            buttonColorScheme: uikit.ButtonColorScheme.accentSecondary,
            primaryIcon: uikit.GeneralIcons.plusCircle,
            // for the first iteration all buttons have same label. Will be changed later
            primaryLabel: context.l10n.addPlace,
            onTap: () {
              onTapMetrics();
              context.router.push(QuickFeedbackRoute());
            },
          ),
        ),
        if (googleSearchOnTap != null)
          AppButton(
            padding: const EdgeInsets.only(left: Spacing.$2x, right: Spacing.$2x, top: Spacing.$2x),
            onTap: googleSearchOnTap,
            buttonColorScheme: ButtonColorScheme.accentSecondary,
            buttonType: ButtonType.secondary,
            primaryLabel: context.l10n.showMore,
            primaryIcon: SystemIcons.search,
          ),
        const SizedBox(height: Spacing.$1_5x),
      ],
    );
  }
}
