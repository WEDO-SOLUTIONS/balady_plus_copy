part of '../content_row.dart';

class ContentRowText extends StatelessWidget {
  /// If we have leading widget or not
  final bool isLeadingExist;

  /// If we have trailing widget or not
  final bool isTrailingExist;

  /// If we support RTL for the texts
  final bool supportTitleRTL;

  /// The options for the text
  final ContentRowTextOptions options;

  const ContentRowText({
    required this.supportTitleRTL,
    required this.options,
    required this.isLeadingExist,
    required this.isTrailingExist,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const startPadding = EdgeInsetsDirectional.only(start: Spacing.$4x);
    const endPadding = EdgeInsetsDirectional.only(end: Spacing.$4x);
    const verticalPadding = EdgeInsetsDirectional.symmetric(vertical: Spacing.$3x);

    final contentPadding = verticalPadding +
        (isLeadingExist ? EdgeInsetsDirectional.zero : startPadding) +
        (isTrailingExist ? EdgeInsetsDirectional.zero : endPadding);

    final textDirection = supportTitleRTL ? Directionality.of(context) : TextDirection.ltr;

    final titleText = options.title;
    final titleStyle = options.titleOptions?.isBold == true
        ? context.textStyles.bodyLargeSemiBold
        : context.textStyles.bodyLargeRegular;
    final titleStyleWithColor =
        titleStyle.copyWith(color: options.titleOptions?.baseColor ?? context.colors.foregroundDefault);

    final titleWidget = titleText != null && titleText.isNotEmpty
        ? Directionality(
            textDirection: textDirection,
            child: ContentRowTitle(
              title: titleText,
              matchedParts: options.titleOptions?.matchedParts,
              style: titleStyleWithColor,
              maxLines: options.titleOptions?.maxLines ?? 1,
            ),
          )
        : null;

    final subtitleText = options.subtitle;
    final subtitleStyle = options.subtitleOptions?.isBold == true
        ? context.textStyles.bodySmallSemiBold
        : context.textStyles.bodySmallRegular;
    final subtitleStyleWithColor =
        subtitleStyle.copyWith(color: options.subtitleOptions?.baseColor ?? context.colors.foregroundSoft);
    final subtitleWidget = subtitleText != null && subtitleText.isNotEmpty
        ? ContentRowSubtitle(
            subtitle: subtitleText,
            maxLines: options.subtitleOptions?.maxLines ?? 1,
            matchedParts: options.subtitleOptions?.matchedParts,
            style: subtitleStyleWithColor,
          )
        : null;

    final subtitleExtraText = options.subtitleExtra;
    final subtitleExtraStyle = options.subtitleExtraOptions?.isBold == true
        ? context.textStyles.bodySmallSemiBold
        : context.textStyles.bodySmallMedium;
    final subtitleExtraStyleWithColor =
        subtitleExtraStyle.copyWith(color: options.subtitleExtraOptions?.baseColor ?? context.colors.foregroundMuted);
    final subtitleExtraWidget = subtitleExtraText != null && subtitleExtraText.isNotEmpty
        ? ContentRowSubtitleExtra(
            subtitleExtra: subtitleExtraText,
            maxLines: options.subtitleExtraOptions?.maxLines ?? 1,
            style: subtitleExtraStyleWithColor,
          )
        : null;
    return Padding(
      padding: contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (titleWidget != null || options.titleOptions?.builder != null)
            options.titleOptions?.builder?.call(context) ?? titleWidget!,
          if (subtitleWidget != null || options.subtitleOptions?.builder != null)
            options.subtitleOptions?.builder?.call(context) ?? subtitleWidget!,
          if (subtitleExtraWidget != null || options.subtitleExtraOptions?.builder != null)
            options.subtitleExtraOptions?.builder?.call(context) ?? subtitleExtraWidget!,
        ].insertBetween(Spacing.$1x.heightBox).toList(),
      ),
    );
  }
}
