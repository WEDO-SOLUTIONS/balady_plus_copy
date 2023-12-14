import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';

import 'package:mapness/shared/config/package_config.dart';

class ServiceCard extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isNetworkImage;

  const ServiceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    this.onTap,
    this.isNetworkImage = false,
  });

  final String title;
  final String subtitle;
  final String image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Text(
                      title,
                      style: Theme.of(context).extension<ThemeTextStyles>()!.textL.copyWith(color: Colors.white),
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
