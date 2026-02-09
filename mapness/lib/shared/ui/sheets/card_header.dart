import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/content_transition.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:sheetify/sheetify.dart';

sealed class CardHeaderData {
  Widget get build;
}

class CardHeaderText extends CardHeaderData {
  final String text;
  final TextStyle style;
  final int maxLines;

  CardHeaderText({required this.text, required this.style, required this.maxLines});

  CardHeaderText.title({required this.text, required BuildContext context, TextStyle? style, int? maxLines})
    : style = style ?? context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
      maxLines = maxLines ?? 2;

  CardHeaderText.subTitle({required this.text, required BuildContext context, TextStyle? style, int? maxLines})
    : style = style ?? context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
      maxLines = maxLines ?? 1;

  @override
  Widget get build => _HeaderText(text: text, maxLines: maxLines, style: style);
}

class CardHeaderWidget extends CardHeaderData {
  final Widget child;

  CardHeaderWidget({required this.child});

  @override
  Widget get build => child;
}

class CardHeader extends SheetAnimatedWidget<PoiCardBottomSheetState> {
  final Function()? onTapClose;
  final BorderRadius borderRadius;

  final CardHeaderData title;
  final CardHeaderData? subTitle;
  final Widget? profileImage;

  const CardHeader({
    required this.onTapClose,
    required this.title,
    this.subTitle,
    this.profileImage,
    this.borderRadius = const BorderRadius.all(Radius.circular(RadiusBorder.m)),
    super.key,
  }) : super(defaultState: PoiCardBottomSheetState.halfOpen);

  @override
  Widget build(BuildContext context, PoiCardBottomSheetState state, double interpolation) {
    final hideSubtitle = state.index > PoiCardBottomSheetState.halfOpen.index;
    var scale = interpolation;

    if (state == PoiCardBottomSheetState.halfOpen) {
      scale = Curves.easeInQuart.transform(1 - interpolation);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (profileImage != null) ...[profileImage!, const SizedBox(width: Spacing.$3x)],
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title.build,
              if (subTitle != null && !hideSubtitle)
                ContentTransition(
                  interpolation: scale,
                  child: Padding(
                    padding: const EdgeInsets.only(top: Spacing.$2x),
                    child: subTitle!.build,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: Spacing.$3x),
        CustomCloseButton(onClose: onTapClose, padding: EdgeInsets.zero),
      ],
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final int maxLines;

  const _HeaderText({required this.text, required this.style, this.maxLines = 1});

  @override
  Widget build(BuildContext context) =>
      Text(text, style: style, overflow: TextOverflow.ellipsis, maxLines: maxLines, textAlign: TextAlign.start);
}
