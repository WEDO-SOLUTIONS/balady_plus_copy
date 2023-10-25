import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Favorites extends StatelessWidget {
  const Favorites({
    super.key,
    required this.background,
    this.horizontalPadding = 8,
  });

  final Color background;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: SvgPicture.asset(
                  "assets/icons/svg/ic_fav.svg",
                  semanticsLabel: 'MinApps Screen',
                  package: "mapness",
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: background,
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Text(
                    '12 دقيقة',
                    style: GoogleFonts.notoSansArabic(
                      textStyle: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  SvgPicture.asset(
                    index % 2 == 1
                        ? "assets/icons/svg/ic_fav_home.svg"
                        : "assets/icons/svg/ic_fav_work.svg",
                    semanticsLabel: 'MinApps Screen',
                    package: "mapness",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
