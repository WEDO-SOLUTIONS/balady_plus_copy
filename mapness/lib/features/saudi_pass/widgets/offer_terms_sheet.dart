import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/shared/hooks/stateless_botomsheet_controller_hook.dart';

class OfferTermsSheet extends HookWidget {
  final String terms;
  final String title;
  final String close;

  const OfferTermsSheet({
    required this.terms,
    required this.title,
    required this.close,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bottomSheetController = useStatelessBottomsheetController(
      onClose: (_) => Navigator.of(context).pop(),
    );
    return StatelessBottomSheet(
      header: Padding(
        padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x, bottom: Spacing.$3x),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: context.textStyleV3.h2SemiBold.copyWith(color: context.colorsV3.foregroundDefault),
              ),
            ),
            Spacing.$3x.widthBox,
            AppButton(
              buttonColorScheme: ButtonColorScheme.secondary,
              size: ButtonSize.small,
              onTap: () => bottomSheetController.close(duration: Duration.zero),
              primaryIcon: SystemIcons.close,
              iconColor: context.colorsV3.neutralOnContainer,
            ),
          ],
        ),
      ),
      content: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: Text(
            terms,
            style: context.textStyleV3.bodySmallRegular.copyWith(color: context.colorsV3.foregroundDefault),
          ),
        ),
      ],
      footer: Container(
        padding: const EdgeInsets.all(Spacing.$4x),
        margin: const EdgeInsetsDirectional.only(bottom: Spacing.$4x),
        color: context.colorsV3.backgroundSurface1,
        child: AppButton(
          buttonColorScheme: ButtonColorScheme.secondary,
          primaryLabel: close,
          onTap: () => bottomSheetController.close(duration: Duration.zero),
        ),
      ),
      scrollController: bottomSheetController,
    );
  }
}
