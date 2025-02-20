import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';

import 'package:mapness/shared/config/package_config.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    required this.title,
    required this.subtitle,
    required this.image,
    super.key,
    this.onTap,
    this.isNetworkImage = false,
  });
  final VoidCallback? onTap;
  final bool isNetworkImage;

  final String title;
  final String subtitle;
  final String image;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          child: Ink.image(
            image: isNetworkImage
                ? NetworkImage(image)
                : AssetImage(
                    image,
                    package: PackageConfig.packageName,
                  ) as ImageProvider,
            fit: BoxFit.cover,
            child: InkWell(
              onTap: onTap ?? () {},
              child: SizedBox(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Text(
                        title,
                        style: Theme.of(context).extension<ThemeTextStyles>()!.heading2.copyWith(color: Colors.white),
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
      );
}
