import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class AddPlaceItem extends StatelessWidget {
  final VoidCallback onTapMetrics;
  const AddPlaceItem({
    required this.onTapMetrics,
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
          style: context.textStyleV3.bodyLargeSemiBold,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Spacing.$1x),
        Text(
          context.l10n.searchAddAnObjectOrCompanyToTheMap,
          style: context.textStyleV3.bodySmallRegular.copyWith(color: context.colorsV3.foregroundSoft),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Spacing.$3x),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: uikit.AppButton(
            buttonColorScheme: uikit.ButtonColorScheme.secondary,
            primaryIcon: uikit.GeneralIcons.plusCircle,
            // for the first iteration all buttons have same label. Will be changed later
            primaryLabel: context.l10n.addPlace,
            onTap: () {
              onTapMetrics();
              context.router.push(QuickFeedbackRoute());
            },
          ),
        ),
        const SizedBox(height: Spacing.$1_5x),
      ],
    );
  }
}
