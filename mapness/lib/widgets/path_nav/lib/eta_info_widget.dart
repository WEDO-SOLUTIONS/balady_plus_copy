import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

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
                style: context.textStyle.heading1.copyWith(color: context.colors.foregroundDefault),
              ),
              Text(
                subtitle ?? '-',
                textAlign: TextAlign.center,
                style: context.textStyle.caption.copyWith(color: NonThemeColor.color38),
              ),
            ],
          ),
        ),
      );
}
