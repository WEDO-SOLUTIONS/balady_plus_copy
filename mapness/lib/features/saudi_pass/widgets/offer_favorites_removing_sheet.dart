import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:sheetify/toggle_sheet/toggle_sheet.dart';

class OfferFavoritesRemovingSheet extends HookWidget {
  final String title;
  final String description;
  final String cancel;
  final String remove;
  final VoidCallback onRemove;

  const OfferFavoritesRemovingSheet({
    required this.title,
    required this.description,
    required this.cancel,
    required this.remove,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bottomSheetController = useToggleSheetController(
      onClose: (_) => Navigator.of(context).pop(),
    );
    return ToggleSheet(
      content: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: context.textStyleV3.h2SemiBold.copyWith(color: context.colorsV3.foregroundDefault),
                        ),
                        Spacing.$1x.heightBox,
                        Text(
                          description,
                          style: context.textStyleV3.bodySmallRegular.copyWith(color: context.colorsV3.foregroundSoft),
                        ),
                      ],
                    ),
                  ),
                  Spacing.$3x.widthBox,
                  AppButton(
                    buttonColorScheme: ButtonColorScheme.secondary,
                    size: ButtonSize.small,
                    onTap: () => bottomSheetController.close(),
                    primaryIcon: SystemIcons.close,
                    iconColor: context.colorsV3.neutralOnContainer,
                  ),
                ],
              ),
              Spacing.$5x.heightBox,
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      primaryLabel: cancel,
                      buttonColorScheme: ButtonColorScheme.secondary,
                      onTap: bottomSheetController.close,
                    ),
                  ),
                  Spacing.$3x.widthBox,
                  Expanded(
                    child: AppButton(
                      primaryLabel: remove,
                      buttonColorScheme: ButtonColorScheme.primary,
                      onTap: () {
                        onRemove();
                        bottomSheetController.close();
                      },
                    ),
                  ),
                ],
              ),
              Spacing.$2x.heightBox,
            ],
          ),
        )
      ],
      scrollController: bottomSheetController,
    );
  }
}
