import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class RemoveHistoryConfirmationPage extends HookConsumerWidget {
  const RemoveHistoryConfirmationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useToggleSheetController(onClose: (controller) => context.router.pop(false));

    final barrierColorDelegate = useMemoized(() => ToggleSheetDelegate.value(context.colors.screenOverlayDimming40));

    return ToggleSheet(
      scrollController: scrollController,
      backgroundColor: context.colors.backgroundSurface4,
      safeAreaColor: context.colors.backgroundSurface4,
      barrierColorDelegate: barrierColorDelegate,
      dragger: SheetDragger(backgroundColor: context.colors.backgroundSurface4),
      outside: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.router.pop(false),
        child: const SizedBox.expand(),
      ),
      content: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.removeHistory,
                          style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
                        ),
                        const SizedBox(height: Spacing.$2x),
                        Text(
                          context.l10n.removeHistoryConfirmation,
                          style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                        ),
                      ],
                    ),
                  ),
                  AppButton.close(
                    onTap: () => context.router.pop(false),
                    padding: EdgeInsets.zero,
                    textColor: context.colors.neutralOnContainer,
                    color: context.colors.neutralContainerDefault,
                    innerPadding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
                  ),
                ],
              ),

              const SizedBox(height: Spacing.$4x),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      buttonColorScheme: ButtonColorScheme.accentSecondary,
                      buttonType: ButtonType.secondary,
                      onTap: () => context.router.pop(false),
                      primaryLabel: context.l10n.cancel,
                      size: ButtonSize.large,
                    ),
                  ),
                  const SizedBox(width: Spacing.$2x),
                  Expanded(
                    child: AppButton(
                      buttonColorScheme: ButtonColorScheme.accentSecondary,
                      onTap: () => context.router.pop(true),
                      primaryLabel: context.l10n.remove,
                      size: ButtonSize.large,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.$4x),
            ],
          ),
        ),
      ],
    );
  }
}
