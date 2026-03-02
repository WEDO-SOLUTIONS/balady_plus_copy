import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/widgets/profile/slide_to_log_out.dart';
import 'package:sheetify/sheetify.dart';

class LogoutSheet extends HookWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onLogout;

  const LogoutSheet({
    required this.onLogout,
    required this.title,
    required this.description,
    required this.buttonText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final toggleSheetController = useToggleSheetController(onClose: (_) => context.router.pop());
    final barrierColorDelegate = useMemoized(() => ToggleSheetDelegate.value(context.colors.screenOverlayDimming40));

    return ToggleSheet(
      barrierColorDelegate: barrierColorDelegate,
      backgroundColor: context.colors.backgroundSurface1,
      safeAreaColor: context.colors.backgroundSurface1,
      dragger: const SheetDragger(),
      header: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault)),
                  const SizedBox(height: Spacing.$1x),
                  Text(
                    description,
                    maxLines: 2,
                    style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Spacing.$2x),
            AppButton.close(onTap: () => context.router.pop()),
          ],
        ),
      ),
      content: [
        Spacing.$3x.heightBox,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x).copyWith(bottom: Spacing.$4x),
          child: SlideToLogout(onLogout: onLogout, buttonText: buttonText),
        ),
      ],
      scrollController: toggleSheetController,
    );
  }
}
