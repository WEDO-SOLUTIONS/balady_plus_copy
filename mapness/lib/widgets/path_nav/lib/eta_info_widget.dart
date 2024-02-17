import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class EtaInfoWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const EtaInfoWidget({
    required this.title,
    required this.subtitle,
    super.key,
  });

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
                    .headingS
                    .copyWith(color: context.color.text_and_icons_base_primary),
              ),
              Text(
                subtitle ?? '-',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .textXS
                    .copyWith(color: const Color(0x7F1E2A36)),
              ),
            ],
          ),
        ),
      );
}
