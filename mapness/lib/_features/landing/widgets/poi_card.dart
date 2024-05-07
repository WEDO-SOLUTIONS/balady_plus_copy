import 'package:balady_uikit/core/colors/app_color_scheme.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/color_scheme.dart';
import 'package:mapness/shared/config/package_config.dart';

class PoiCard extends ConsumerWidget {
  const PoiCard({
    required this.onTap,
    required this.title,
    required this.subtitle,
    required this.image,
    super.key,
  });

  final Function() onTap;
  final String title;
  final String subtitle;
  final String image;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          child: Ink.image(
            image: NetworkImage(
              image,
            ),
            fit: BoxFit.cover,
            child: Container(
              decoration: ref.read(colorSchemeProvider) == AppColorScheme.brown
                  ? const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/places_card_mask.png',
                          package: PackageConfig.packageName,
                        ),
                        fit: BoxFit.cover,
                      ),
                    )
                  : null,
              child: InkWell(
                onTap: onTap,
                child: SizedBox(
                  width: 163,
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 13, vertical: 15,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Text(
                          title,
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()!
                              .callout
                              .copyWith(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          subtitle,
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()!
                              .footNote
                              .copyWith(color: Colors.white.withOpacity(0.8)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
