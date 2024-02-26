import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';


import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class PrayerCard extends StatelessWidget {
  const PrayerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
        child: Ink.image(
          image: const AssetImage(
            'assets/images/prayer_time.png',
            package: PackageConfig.packageName,
          ),
          fit: BoxFit.cover,
          child: InkWell(
            onTap: () {},
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 24,
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.presentTime,
                          style: Theme.of(context).extension<ThemeTextStyles>()!.accentXS.copyWith(color: Colors.white),
                        ),
                        Text(
                          '05:18 pm',
                          style: Theme.of(context).extension<ThemeTextStyles>()!.headingS.copyWith(color: Colors.white),
                        ),
                        const Spacer(),
                        Text(
                          context.l10n.remainingTimeForPrayer,
                          style: Theme.of(context).extension<ThemeTextStyles>()!.accentXS.copyWith(color: Colors.white),
                        ),
                        Text(
                          '01:26:04',
                          style: Theme.of(context).extension<ThemeTextStyles>()!.headingM.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
