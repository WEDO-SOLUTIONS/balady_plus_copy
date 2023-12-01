import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';


import 'package:mapness/shared/config/package_config.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  final String title;
  final String subtitle;
  final String image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
        child: Ink.image(
          image: AssetImage(
            image,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Text(
                      title,
                      style: Theme.of(context).extension<ThemeTextStyles>()!.accentL.copyWith(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).extension<ThemeTextStyles>()!.textS.copyWith(color: Colors.white.withOpacity(0.8)),
                    )
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
