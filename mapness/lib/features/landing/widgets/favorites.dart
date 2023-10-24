import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Favorites extends StatelessWidget {
  const Favorites({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        // reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F4F8),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: SvgPicture.asset(
                  "assets/icons/svg/ic_dashboard_fav.svg",
                  semanticsLabel: 'MinApps Screen',
                  package: "mapness",
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF1F4F8),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 10,
              ),
              child: Row(
                children: [
                  const Icon(Icons.house),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    '12 دقيقة',
                    style: GoogleFonts.notoSansArabic(
                      textStyle: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
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
