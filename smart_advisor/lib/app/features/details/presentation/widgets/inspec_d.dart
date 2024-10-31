// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import '/app/core/utils/constants/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class InspecD extends StatelessWidget {
  const InspecD({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 500,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 45, right: 26, left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'بند ١',
                    style: GoogleFonts.cairo(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SvgPicture.asset(
                      'packages/smart_advisor/smart_advisor_assets/images/close.svg')
                ],
              ),
              Text(
                'القاء مخالفات البناء خارج حدود السور المؤقت او الحاويه ',
                style:
                    GoogleFonts.cairo(fontSize: 16, color: Color(0xFF656A73)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 277,
                            width: 263,
                            child: Image.asset(
                              'packages/smart_advisor/smart_advisor_assets/images/face-3.png',
                            ),
                          ),
                          Positioned(
                            top: 230,
                            left: 150,
                            child: Container(
                              width: 102,
                              height: 33,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13.27),
                                color: Color(0xffE94B3E),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.close,
                                    color: Color(0xffFFFFFF),
                                    size: 18,
                                  ),
                                  Text(
                                    ("non_compliant").tr(),
                                    style: GoogleFonts.cairo(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16), // Optional spacing between items
                      Stack(
                        children: [
                          Container(
                              height: 277,
                              width: 263,
                              child: Image.asset(
                                  'packages/smart_advisor/smart_advisor_assets/images/face-333.png')),
                          Positioned(
                            top: 230,
                            left: 150,
                            child: Container(
                              width: 102,
                              height: 33,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13.27),
                                color: Color(0xff67A86A),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: Color(0xffFFFFFF),
                                    size: 18,
                                  ),
                                  Text(
                                    ("compliant").tr(),
                                    style: GoogleFonts.cairo(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
