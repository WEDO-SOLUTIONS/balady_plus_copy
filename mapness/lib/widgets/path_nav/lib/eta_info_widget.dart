import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';


class EtaInfoWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  const EtaInfoWidget({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: 65,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title ?? '-',
              textAlign: TextAlign.center,
              style: Theme.of(context).extension<ThemeTextStyles>()!.headingS.copyWith(color: const Color(0xFF1D2A36)),
            ),
            Text(
              subtitle ?? '-',
              textAlign: TextAlign.center,
              style: Theme.of(context).extension<ThemeTextStyles>()!.textXS.copyWith(color: const Color(0x7F1E2A36)),
            ),
          ],
        ),
      ),
    );
  }
}
