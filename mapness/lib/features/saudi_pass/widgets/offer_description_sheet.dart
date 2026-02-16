import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sheetify/sheetify.dart';

class OfferDescriptionSheet extends HookWidget {
  final String terms;
  final String title;
  final String close;

  const OfferDescriptionSheet({required this.terms, required this.title, required this.close, super.key});

  @override
  Widget build(BuildContext context) => ToggleSheet(
    useSafeArea: false,
    dragger: DraggerContainer(draggerColor: context.colors.backgroundSurface5),
    backgroundColor: context.colors.backgroundSurface1,
    safeAreaColor: context.colors.backgroundSurface1,
    header: Padding(
      padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x, bottom: Spacing.$3x),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: context.textStyles.h2SemiBold.copyWith(color: context.colors.foregroundDefault)),
          ),
          Spacing.$3x.widthBox,
          AppButton.close(onTap: () => Navigator.pop(context), padding: EdgeInsets.zero),
        ],
      ),
    ),
    content: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        child: Text(
          terms,
          style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundDefault),
        ),
      ),
    ],
    footer: Container(
      padding: const EdgeInsets.all(Spacing.$4x),
      margin: const EdgeInsetsDirectional.only(bottom: Spacing.$4x),
      color: context.colors.backgroundSurface1,
      child: AppButton(
        size: ButtonSize.large,
        primaryLabel: close,
        color: context.colors.accentSecondaryContainerDefault,
        textColor: context.colors.accentSecondaryOnContainer,
        buttonColorScheme: ButtonColorScheme.accent,
        onTap: () => Navigator.pop(context),
      ),
    ),
    scrollController: ToggleSheetController(),
  );
}
