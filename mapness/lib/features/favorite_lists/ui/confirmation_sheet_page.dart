import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_api_exception.dart';
import 'package:mapness/features/favorite_lists/ui/models/sheet_action_button.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class ConfirmationSheetPage extends HookConsumerWidget {
  final String title;
  final String message;
  final List<SheetActionButton> buttons;

  const ConfirmationSheetPage({
    required this.title,
    required this.message,
    required this.buttons,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useToggleSheetController(onClose: (_) => context.router.pop());
    final submittingIndex = useState<int?>(null);

    Future<void> handleTap(int index, SheetActionButton button) async {
      if (!button.showsLoadingAndHandlesErrors) {
        await button.onTap();
        return;
      }
      if (submittingIndex.value != null) {
        return;
      }
      submittingIndex.value = index;
      try {
        await button.onTap();
        if (context.mounted) {
          context.router.pop(true);
        }
      } catch (e) {
        submittingIndex.value = null;
        if (context.mounted) {
          final errorMessage = e is FavoriteListsApiException
              ? e.localizedMessage(ref.read(appLanguageProvider))
              : context.l10n.somethingWentWrongPleaseTryAgainLater;
          ToastOverlay.of(context).show(title: errorMessage, isDismissible: true);
        }
      }
    }

    return ToggleSheet(
      scrollController: scrollController,
      backgroundColor: context.colors.backgroundSurface4,
      safeAreaColor: context.colors.backgroundSurface4,
      dragger: SheetDragger(draggerColor: context.colors.backgroundSurface5),
      outside: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.router.pop(),
        child: const SizedBox.expand(),
      ),
      header: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Spacing.$2_5x,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Spacing.$1x,
                children: [
                  Text(
                    title,
                    style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
                  ),
                  Text(
                    message,
                    style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => context.router.pop(),
              icon: const Icon(SystemIcons.close),
            ),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.all(Spacing.$4x),
      content: [
        Row(
          spacing: Spacing.$3x,
          children: [
            for (final (index, button) in buttons.indexed)
              Expanded(
                child: BaladyAppButton(
                  primaryLabel: button.label,
                  buttonColorScheme: button.buttonColorScheme,
                  buttonType: button.buttonType,
                  buttonState: submittingIndex.value == index ? ButtonState.loading : ButtonState.defaultState,
                  onTap: () => handleTap(index, button),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
