import 'package:balady_uikit/components/layouts/spacing.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';

class ContentRow extends StatelessWidget {
  final Widget? child;
  final Widget? icon1st;
  final Widget? icon2nd;
  final String? title;
  final String? subtitle;
  final String? subtitleExtra;
  final String? actionText;
  final Widget? actionIcon;
  final BoxDecoration? decoration;
  final void Function()? onTap;

  const ContentRow({
    super.key,
    this.child,
    this.icon1st,
    this.icon2nd,
    this.title,
    this.subtitle,
    this.subtitleExtra,
    this.actionText,
    this.actionIcon,
    this.decoration,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
      color: Colors.transparent,
      // borderRadius: borderRadius,
      child: InkWell(
        // borderRadius: borderRadius,
        onTap: onTap,
        child: Container(
          decoration: decoration,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: Spacing.verticalPaddingInsideCell,
            horizontal: Spacing.horizontalPaddingInsideWrapper,
          ),
          child: child ??
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                if (icon1st != null) ...[
                  icon1st!,
                  const SizedBox(
                    width: Spacing.horizontalGapBetweenCellContent,
                  ),
                ],
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (title != null) ...[
                        Text(
                          title!,
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()
                              ?.textM,
                        ),
                      ],
                      if (subtitle != null) ...[
                        const SizedBox(
                          width: Spacing.verticalGapBetweenCellContent,
                        ),
                        Text(
                          subtitle!,
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()
                              ?.textS,
                        )
                      ],
                      if (subtitleExtra != null) ...[
                        const SizedBox(
                          width: Spacing.verticalGapBetweenCellContent,
                        ),
                        Text(
                          subtitleExtra!,
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()
                              ?.accentS,
                        )
                      ],
                    ]),
                Spacer(),
                if (actionText != null) ...[
                  Text(
                    actionText!,
                    style:
                        Theme.of(context).extension<ThemeTextStyles>()?.accentM,
                  )
                ],
                if (actionIcon != null) ...[
                  const SizedBox(
                    width: Spacing.horizontalGapBetweenChipContent,
                  ),
                  actionIcon!,
                ],
                if (icon2nd != null) ...[
                  const SizedBox(
                    width: Spacing.horizontalGapBetweenCellContent,
                  ),
                  icon2nd!,
                ],
              ]),
        ),
      ),
    );
}
