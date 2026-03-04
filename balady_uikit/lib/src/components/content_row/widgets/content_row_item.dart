part of '../content_row.dart';

/// A function type that defines the signature for a row content builder.
///
/// The [RowContentBuilder] takes a [BuildContext] and a [Widget] as parameters
/// and returns a [Widget]. It is typically used to build custom title, subtitle and extrasubtitles of [ContentRow]
typedef RowContentBuilder = Widget Function(BuildContext context);

class ContentRowItem extends StatelessWidget {
  final bool? supportTitleRTL;

  final Widget? leading;
  final Widget? trailing;
  final String? title;
  final String? subtitle;
  final String? subtitleExtra;

  final TextStyle? titleStyle;
  final int? titleMaxlines;
  final List<UIMarkedUpTextSpan>? titleMatchedParts;
  final int? subtitleMaxlines;
  final int? subtitleExtraMaxlines;
  final List<UIMarkedUpTextSpan>? subtitleMatchedParts;
  final TextStyle? subtitleStyle;

  final CrossAxisAlignment? crossAxisAlignment;

  final RowContentBuilder? titleBuilder;
  final RowContentBuilder? subtitleBuilder;
  final RowContentBuilder? subtitleExtraBuilder;

  const ContentRowItem({
    this.titleMatchedParts,
    this.subtitleMatchedParts,
    this.leading,
    this.trailing,
    this.title,
    this.subtitle,
    this.subtitleExtra,
    this.titleStyle,
    this.titleMaxlines,
    this.subtitleStyle,
    super.key,
    this.subtitleMaxlines,
    this.subtitleExtraMaxlines,
    this.crossAxisAlignment,
    this.supportTitleRTL,
    this.titleBuilder,
    this.subtitleBuilder,
    this.subtitleExtraBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle_ = context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundDefault);
    final titleWidget = title != null && title!.isNotEmpty
        ? Directionality(
            textDirection: supportTitleRTL ?? false ? Directionality.of(context) : TextDirection.ltr,
            child: ContentRowTitle(
              title: title!,
              matchedParts: titleMatchedParts,
              style: titleStyle ?? titleStyle_,
              maxLines: titleMaxlines ?? 1,
            ),
          )
        : null;

    final subtitleStyle_ = context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft);
    final subtitleWidget = subtitle != null && subtitle!.isNotEmpty
        ? ContentRowSubtitle(
            subtitle: subtitle!,
            maxLines: subtitleMaxlines ?? 1,
            style: subtitleStyle ?? subtitleStyle_,
            matchedParts: subtitleMatchedParts,
          )
        : null;

    final subtitleExtraStyle_ = context.textStyles.bodySmallMedium.copyWith(color: context.colors.foregroundMuted);
    final subtitleExtraWidget = subtitleExtra != null && subtitleExtra!.isNotEmpty
        ? ContentRowSubtitleExtra(
            subtitleExtra: subtitleExtra!,
            maxLines: subtitleExtraMaxlines ?? 1,
            style: subtitleExtraStyle_,
          )
        : null;

    return Row(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) leading!,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (titleWidget != null || titleBuilder != null) titleBuilder?.call(context) ?? titleWidget!,
              if (subtitleWidget != null || subtitleBuilder != null) subtitleBuilder?.call(context) ?? subtitleWidget!,
              if (subtitleExtraWidget != null || subtitleExtraBuilder != null)
                subtitleExtraBuilder?.call(context) ?? subtitleExtraWidget!,
            ]
                .insertBetween(
                  Spacing.$0_5x.heightBox,
                )
                .toList(),
          ),
        ),
        if (trailing != null) trailing!,
      ].insertBetween(Spacing.$3x.widthBox).toList(),
    );
  }
}
