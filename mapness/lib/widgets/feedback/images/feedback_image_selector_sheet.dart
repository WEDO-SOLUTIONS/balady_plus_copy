import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/stateless_botomsheet_controller_hook.dart';

enum FeedbackImageSelectorType {
  camera,
  gallery,
}

class FeedbackImageSelectorSheet extends HookWidget {
  final ValueChanged<FeedbackImageSelectorType?>? onSelect;

  const FeedbackImageSelectorSheet({super.key, this.onSelect});

  @override
  Widget build(BuildContext context) {
    final sheetController = useStatelessBottomsheetController(
      onClose: (_) => onSelect != null ? onSelect?.call(null) : context.router.popForced,
    );

    return StatelessBottomSheet(
      safeAreaColor: context.colors.backgroundSurface4,
      backgroundColor: context.colors.backgroundSurface4,
      scrollController: sheetController,
      draggerColor: context.colors.backgroundSurface4,
      content: [
        ContentRow(
          options: ContentRowOptions(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
            title: context.l10n.addPhoto,
            titleStyle: context.textStyles.h4SemiBold.copyWith(
              color: context.colors.foregroundDefault,
            ),
            customActionWidget: AppButton.close(
              color: context.colors.neutralContainerDefault,
              onTap: context.router.popForced,
              innerPadding: const EdgeInsets.all(Spacing.$2x),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        const SizedBox(height: Spacing.$4x),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
            child: ContentWrapper(color: context.colors.backgroundSurface1, children: [
              ContentRow(
                isDividerEnabled: true,
                onTap: () => onSelect != null
                    ? onSelect?.call(FeedbackImageSelectorType.camera)
                    : Navigator.of(context).pop(FeedbackImageSelectorType.camera),
                leading: AppIcons(
                  iconData: GeneralIcons.photo,
                  color: context.colors.accentDefault,
                ),
                text: ContentRowTextOptions(
                  title: context.l10n.takePhoto,
                ),
                trailing: ContentRowCustomTrailingOptions(
                  builder: (context) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                    child: AppIcons(
                      iconData: SystemIcons.arrowCornerRightLarge,
                      color: context.colors.foregroundMuted,
                    ),
                  ),
                ),
              ),
              ContentRow(
                onTap: () => onSelect != null
                    ? onSelect?.call(FeedbackImageSelectorType.gallery)
                    : Navigator.of(context).pop(FeedbackImageSelectorType.gallery),
                leading: AppIcons(
                  iconData: SystemIcons.images,
                  color: context.colors.accentDefault,
                ),
                text: ContentRowTextOptions(
                  title: context.l10n.chooseFromGallery,
                ),
                trailing: ContentRowCustomTrailingOptions(
                  builder: (context) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                    child: AppIcons(
                      iconData: SystemIcons.arrowCornerRightLarge,
                      color: context.colors.foregroundMuted,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
