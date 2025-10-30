import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/core/utils/constants/paths/icon_paths.dart';
import '/app/core/utils/constants/language.dart';

class VbHeader extends StatefulWidget {
  const VbHeader({super.key});

  @override
  State<VbHeader> createState() => _VbHeaderState();
}

class _VbHeaderState extends State<VbHeader> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      InkWell(
        onTap: () {},
        child: Container(
          height: 281,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                "packages/smart_advisor/smart_advisor_assets/images/BVbackg.png",
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsetsDirectional.only(top: 50, end: 16, start: 16),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //SvgPicture.asset(IconPath.home),
              SvgPicture.asset(IconPath.arrowRight),
            ],
          ),
          Text(
            ("building_violations").tr(),
            style: GoogleFonts.cairo(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.w800),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Container(
              height: 158,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ("description").tr(),
                      style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0E615F)),
                    ),
                    Text(
                      'هي المخالفات التي تنتج عن اعمال البناء او الهدم اوالترميم والتي يلزم التعاقد مع ناقل نفايات معتمد يوفر حاويات لنقلها وعدم الفائها في الاراضي الفضاء او خارج حدود السور المؤقت للمباني الانشائيه',
                      maxLines: 4,
                      style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: const Color(0xFF5A5A5A),
                          height: 1.7),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    ]);
  }
}
