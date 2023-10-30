import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/features/common/config/package_fonts.dart';
import 'package:mapness/features/common/config/package_config.dart';

class PrayerCard extends StatelessWidget {
  const PrayerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
        child: Ink.image(
          image: const AssetImage(
            "assets/images/prayer_time.png",
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
                          "الوقت الحالي",
                          style: PackageFonts.frutigerArabic(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                        Text(
                          "05:18 pm",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 19,
                            height: 1.4,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "الوقت المتبقي الى الصلاة",
                          style: PackageFonts.frutigerArabic(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                        Text(
                          "01:26:04",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            height: 1.1,
                          ),
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
