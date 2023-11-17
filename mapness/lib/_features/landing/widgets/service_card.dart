import 'package:flutter/material.dart';
import 'package:mapness/shared/config/package_fonts.dart';
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
                      style: PackageFonts.frutigerArabic(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: PackageFonts.frutigerArabic(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        height: 1.5,
                      ),
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
