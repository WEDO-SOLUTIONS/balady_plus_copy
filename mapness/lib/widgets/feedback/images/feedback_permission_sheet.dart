import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/widgets/feedback/images/feedback_image_selector_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sheetify/sheetify.dart';

class FeedbackPermissionSheet extends HookWidget {
  final FeedbackImageSelectorType type;

  const FeedbackPermissionSheet({required this.type, super.key});

  @override
  Widget build(BuildContext context) {
    final sheetController = useToggleSheetController(onClose: (_) => Navigator.of(context).pop());

    return ToggleSheet(
      safeAreaColor: context.colors.backgroundSurface4,
      backgroundColor: context.colors.backgroundSurface4,
      scrollController: sheetController,
      dragger: SheetDragger(backgroundColor: context.colors.backgroundSurface4),
      content: [
        ContentRow(
          options: ContentRowOptions(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
            title: switch (type) {
              FeedbackImageSelectorType.camera => context.l10n.allowAccessToCamera,
              FeedbackImageSelectorType.gallery => context.l10n.allowAccessToPhotos,
            },
            titleStyle: context.textStyles.h3SemiBold.copyWith(color: context.colors.foregroundDefault),
            customActionWidget: AppButton.close(
              color: context.colors.neutralContainerDefault,
              onTap: () => Navigator.pop(context),
              innerPadding: const EdgeInsets.all(Spacing.$2x),
              padding: const EdgeInsetsDirectional.only(end: Spacing.$4x),
            ),
          ),
        ),
        const SizedBox(height: Spacing.$2x),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: Text(switch (type) {
            FeedbackImageSelectorType.camera => context.l10n.accessCameraPermissionDesc,
            FeedbackImageSelectorType.gallery => context.l10n.accessGalleryPermissionDesc,
          }, style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft)),
        ),
        const SizedBox(height: Spacing.$6x),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: Row(
            children: [
              Expanded(
                child: AppButton(
                  onTap: () => Navigator.pop(context),
                  primaryLabel: context.l10n.cancel,
                  padding: const EdgeInsets.symmetric(vertical: Spacing.$2x),
                  buttonType: ButtonType.secondary,
                  buttonColorScheme: ButtonColorScheme.accentSecondary,
                  size: ButtonSize.large,
                ),
              ),
              const SizedBox(width: Spacing.$4x),
              Expanded(
                child: AppButton(
                  onTap: () {
                    Navigator.pop(context);
                    openAppSettings();
                  },
                  primaryLabel: context.l10n.goToSettings,
                  padding: const EdgeInsets.symmetric(vertical: Spacing.$2x),
                  buttonColorScheme: ButtonColorScheme.accent,
                  size: ButtonSize.large,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.$4x),
      ],
    );
  }
}
