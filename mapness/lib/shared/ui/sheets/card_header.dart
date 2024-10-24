import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class CardHeader extends StatelessWidget {
  final Function()? onTapClose;
  final BorderRadius borderRadius;

  final String? title;
  final int titleMaxLines;
  final Widget? titleWidget;

  final String? subTitle;
  final TextStyle? subTitleStyle;
  final Widget? subTitleWidget;

  final Widget? profileImage;

  const CardHeader({
    required this.onTapClose,
    this.title,
    this.titleMaxLines = 2,
    this.titleWidget,
    this.subTitle,
    this.subTitleStyle,
    this.subTitleWidget,
    this.profileImage,
    this.borderRadius = const BorderRadius.all(Radius.circular(RadiusBorder.m)),
    super.key,
  })  : assert(!(title != null && titleWidget != null), 'Use only [title] or [titleWidget] at the same time'),
        assert(
            !(subTitle != null && subTitleWidget != null), 'Use only [subTitle] or [subTitleWidget] at the same time');

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    final titleWidget = this.titleWidget;

    final subTitleStyle =
        this.subTitleStyle ?? context.textStyleV3.bodySmallRegular.copyWith(color: context.colorsV2.foregroundSoft);

    final subTitle = this.subTitle;
    final subTitleWidget = this.subTitleWidget;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (profileImage != null) ...[
          profileImage!,
          const SizedBox(width: Spacing.$3x),
        ],
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) _Title(title: title, maxLines: titleMaxLines),
              if (titleWidget != null) titleWidget,
              if (subTitle != null)
                Text(
                  subTitle,
                  style: subTitleStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                ),
              if (subTitleWidget != null) subTitleWidget,
            ],
          ),
        ),
        const SizedBox(width: Spacing.$3x),
        Padding(
          padding: const EdgeInsets.only(bottom: Spacing.$4x),
          child: Material(
            borderRadius: borderRadius,
            child: InkWell(
              borderRadius: borderRadius,
              onTap: onTapClose,
              child: SizedBox(
                height: Spacing.$10x,
                width: Spacing.$10x,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(RadiusBorder.m),
                    color: context.color.textAndIconsBasePrimary.withAlpha(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.$2x),
                    child: SystemIcons.close.icon(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  final String title;
  final int maxLines;

  const _Title({
    required this.title,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: context.textStyle.heading1.copyWith(
          color: context.color.textAndIconsBasePrimary,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
        textAlign: TextAlign.start,
      );
}
