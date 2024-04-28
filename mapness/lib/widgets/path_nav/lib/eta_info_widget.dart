import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class EtaInfoWidget extends StatelessWidget {

  const EtaInfoWidget({
    required this.title,
    required this.subtitle,
    super.key,
  });
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 65,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title ?? '-',
                textAlign: TextAlign.center,
                textHeightBehavior: const TextHeightBehavior(
                  // applyHeightToFirstAscent: false,
                  applyHeightToLastDescent: false,
                ),
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .heading1
                    .copyWith(color: context.color.textAndIconsBasePrimary),
              ),
              Text(
                subtitle ?? '-',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .caption
                    .copyWith(color: NonThemeColor.color38),
              ),
            ],
          ),
        ),
      );
}
