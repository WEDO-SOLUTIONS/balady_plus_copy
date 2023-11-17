import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/shared/config/package_fonts.dart';
import 'package:mapness/shared/config/package_config.dart';

class PoiCard extends ConsumerWidget {
  const PoiCard({
    super.key,
    required this.objectId,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  final DgisObjectIdMessage objectId;
  final String title;
  final String subtitle;
  final String image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            onTap: () {
              PoiMapRoute(dgisObjectId: objectId.objectId).push(context);
            },
            child: SizedBox(
              width: 163,
              height: 200,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Text(
                      title,
                      style: PackageFonts.frutigerArabic(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
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
