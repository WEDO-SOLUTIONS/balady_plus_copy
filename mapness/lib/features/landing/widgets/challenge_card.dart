import 'package:flutter/material.dart';
import 'package:mapness/features/common/config/package_config.dart';

import '../../common/config/package_fonts.dart';

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
        child: Ink.image(
          image: const AssetImage(
            "assets/images/challenge.png",
            package: PackageConfig.packageName,
          ),
          fit: BoxFit.cover,
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 24,
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "تحدي بلدي",
                          style: PackageFonts.frutigerArabic(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        SizedBox(
                          width: 190,
                          child: Text(
                            "وساهم في تصدي مظاهر التلوث البصري في مدينتك",
                            style: PackageFonts.frutigerArabic(
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        SizedBox(
                          width: 117,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: Text(
                              "ابدأ التحدي",
                              textAlign: TextAlign.center,
                              style: PackageFonts.frutigerArabic(
                                color: const Color(0xFF4CA5B4),
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
