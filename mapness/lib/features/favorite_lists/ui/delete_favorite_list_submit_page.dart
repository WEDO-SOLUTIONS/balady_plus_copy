import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_api_exception.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class DeleteFavoriteListSubmitPage extends HookConsumerWidget {
  final String title;
  final String message;
  final Future<void> Function() onConfirm;

  const DeleteFavoriteListSubmitPage({
    required this.title,
    required this.message,
    required this.onConfirm,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useToggleSheetController(onClose: (_) => context.router.pop());
    final isSubmitting = useState(false);

    Future<void> confirm() async {
      if (isSubmitting.value) {
        return;
      }
      isSubmitting.value = true;
      try {
        await onConfirm();
        if (context.mounted) {
          context.router.pop(true);
        }
      } catch (e) {
        isSubmitting.value = false;
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
            Expanded(
              child: BaladyAppButton(
                primaryLabel: context.l10n.cancel,
                buttonColorScheme: ButtonColorScheme.accentSecondary,
                buttonType: ButtonType.secondary,
                onTap: context.router.pop,
              ),
            ),
            Expanded(
              child: BaladyAppButton(
                primaryLabel: context.l10n.delete,
                buttonColorScheme: ButtonColorScheme.error,
                buttonState: isSubmitting.value ? ButtonState.loading : ButtonState.defaultState,
                onTap: confirm,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
