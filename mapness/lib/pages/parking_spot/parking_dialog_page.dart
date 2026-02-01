import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class ParkingDialogPage extends HookConsumerWidget {
  final String title;
  final String? desc;
  final VoidCallback onAcceptTab;
  final VoidCallback onCancelTab;

  const ParkingDialogPage({
    required this.title,
    required this.onAcceptTab,
    required this.onCancelTab,
    this.desc,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useToggleSheetController();

    final bottomPadding = math.max(MediaQuery.of(context).viewPadding.bottom, Spacing.px);
    return ToggleSheet(
      scrollController: controller,
      backgroundColor: context.colors.backgroundSurface1,
      safeAreaColor: context.colors.backgroundSurface1,
      dragger: const SheetDragger(),
      content: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: Row(
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundSoft)),
                    if (desc != null) Spacing.$1x.heightBox,
                    if (desc != null)
                      Text(
                        desc!,
                        style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                      ),
                  ],
                ),
              ),
              Spacing.$3x.widthBox,
              AppButton(
                buttonColorScheme: ButtonColorScheme.neutral,
                primaryIcon: SystemIcons.close,
                onTap: () => context.router.pop(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(Spacing.$4x).copyWith(bottom: 0),
          child: AppButton(
            buttonColorScheme: ButtonColorScheme.accent,
            primaryLabel: context.l10n.accept,
            onTap: onAcceptTab,
          ),
        ),
        Spacing.$2x.heightBox,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: AppButton(
            buttonColorScheme: ButtonColorScheme.accentSecondary,
            primaryLabel: context.l10n.cancel,
            onTap: onCancelTab,
          ),
        ),
        bottomPadding.heightBox,
      ],
    );
  }
}
