import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class ThanksSheet extends StatelessWidget {
  const ThanksSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SvgPicture.asset(
              'assets/images_svg/illustration_thanks.svg',
              package: PackageConfig.packageName,
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.thanksForYourFeedback,
              textAlign: TextAlign.center,
              style: Theme.of(context).extension<ThemeTextStyles>()!.textL.copyWith(color: const Color(0xB21E2A36)),
            ),
          ],
        ),
      ),
    );
  }
}
