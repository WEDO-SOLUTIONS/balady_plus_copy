import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/stateless_botomsheet_controller_hook.dart';
import 'package:mapness/shared/ui/safe_area_padding.dart';

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

    return SafeAreaPadding(
      bottom: false,
      child: StatelessBottomSheet(
        safeAreaColor: context.colorsV3.backgroundSurface4,
        backgroundColor: context.colorsV3.backgroundSurface4,
        scrollController: sheetController,
        draggerColor: context.colorsV3.backgroundSurface4,
        content: [
          ContentRow(
            options: ContentRowOptions(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
              title: context.l10n.addPhoto,
              titleStyle: context.textStyleV3.h4SemiBold.copyWith(
                color: context.colorsV3.foregroundDefault,
              ),
              customActionWidget: AppButton.close(
                color: context.colorsV3.neutralContainerDefault,
                onTap: context.router.popForced,
                innerPadding: const EdgeInsets.all(Spacing.$2x),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$4x),
            child: ContentWrapper(color: context.colorsV3.backgroundSurface1, children: [
              ContentRowV2(
                isDividerEnabled: true,
                onTap: () => onSelect != null
                    ? onSelect?.call(FeedbackImageSelectorType.camera)
                    : Navigator.of(context).pop(FeedbackImageSelectorType.camera),
                leading: AppIcons(
                  iconData: GeneralIcons.photo,
                  color: context.colorsV3.accentDefault,
                ),
                text: ContentRowTextOptions(
                  title: context.l10n.takePhoto,
                ),
                trailing: ContentRowCustomTrailingOptions(
                  builder: (context) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                    child: AppIcons(
                      iconData: SystemIcons.arrowCornerRightLarge,
                      color: context.colorsV3.foregroundMuted,
                    ),
                  ),
                ),
              ),
              ContentRowV2(
                onTap: () => onSelect != null
                    ? onSelect?.call(FeedbackImageSelectorType.gallery)
                    : Navigator.of(context).pop(FeedbackImageSelectorType.gallery),
                leading: AppIcons(
                  iconData: SystemIcons.images,
                  color: context.colorsV3.accentDefault,
                ),
                text: ContentRowTextOptions(
                  title: context.l10n.chooseFromGallery,
                ),
                trailing: ContentRowCustomTrailingOptions(
                  builder: (context) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                    child: AppIcons(
                      iconData: SystemIcons.arrowCornerRightLarge,
                      color: context.colorsV3.foregroundMuted,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
