// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import '/app/core/utils/constants/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class InvesmentCard extends StatelessWidget {
  const InvesmentCard({Key? key})
      : super(key: key); // Corrected constructor declaration

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 364,
      height: 281,
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ايجار مؤقت',
                      style: GoogleFonts.cairo(
                        color: Color(0xffA3C669),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    // SizedBox(height: 8),

                    Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: Color(0xffF5F7F9),
                        borderRadius: BorderRadius.circular(214),
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.favorite_border),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'وزارة الشؤون البلدية والقروية والاسكان',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xffF5F7F9)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ("space").tr(),
                        style: GoogleFonts.cairo(
                            color: Color(0xff5E6C79), fontSize: 14),
                      ),
                      Text(
                        '3000 م٢',
                        style: GoogleFonts.cairo(fontSize: 16),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 100,
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xffF5F7F9)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ("invesduration").tr(),
                        style: GoogleFonts.cairo(
                            color: Color(0xff5E6C79), fontSize: 14),
                      ),
                      Text(
                        '23 شهر ',
                        style: GoogleFonts.cairo(fontSize: 16),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 100,
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xffF5F7F9)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ("invesduration").tr(),
                        style: GoogleFonts.cairo(
                            color: Color(0xff5E6C79), fontSize: 14),
                      ),
                      Text(
                        'الرياض',
                        style: GoogleFonts.cairo(fontSize: 16),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              width: 93,
              height: 27,
              decoration: BoxDecoration(
                  color: Color.fromARGB(13, 196, 142, 77),
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                  child: Text(
                'الطرق والارصفه',
                style: GoogleFonts.cairo(
                    color: Color(0xffC48E4D),
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              )),
            ),
            SizedBox(
              height: 8,
            ),
            Divider(
              color: Color.fromARGB(50, 69, 81, 84),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                        'packages/smart_advisor/smart_advisor_assets/images/Icons.svg'),
                    SizedBox(
                      width: 6,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ("entity").tr(),
                          style: GoogleFonts.cairo(color: Color(0xff5E6C79)),
                        ),
                        Text(
                          'محطه وقود',
                          style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        )
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ريال / م٢ اليوم',
                      style: GoogleFonts.cairo(color: Color(0xff5E6C79)),
                    ),
                    Text(
                      '0.034',
                      style: GoogleFonts.cairo(fontSize: 20),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
