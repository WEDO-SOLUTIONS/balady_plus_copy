// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/core/utils/constants/language.dart';

// ignore: constant_identifier_names

class DetailsFineFees extends StatefulWidget {
  const DetailsFineFees({super.key});

  @override
  State<DetailsFineFees> createState() => _GState();
}

class _GState extends State<DetailsFineFees> {
  int _selectedIndex = 0;
  List<String> texts = [
    'رابع مره',
    'ثالث مره',
    'ثاني مره',
    'الغرامة اول مره',
  ];
  void _onSegment(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          ("fine_fees").tr(),
          style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(texts.length, (index) {
            return GestureDetector(
              onTap: () => _onSegment(index),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: _selectedIndex == index
                      ? Color(0xff2E7998)
                      : Color.fromRGBO(142, 154, 158, 0.096),
                ),
                child: Center(
                  child: Text(
                    texts[index],
                    style: GoogleFonts.cairo(
                      color: _selectedIndex == index
                          ? Colors.white
                          : Color(0xff191925),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Color.fromRGBO(142, 154, 158, 0.096)),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'ريال',
                    style: GoogleFonts.cairo(color: Color(0xff2E7998)),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    '${_selectedIndex == 0 ? '8000' : _selectedIndex == 1 ? '6000' : _selectedIndex == 2 ? '4000' : _selectedIndex == 3 ? '2000' : ''}',
                    style: GoogleFonts.cairo(
                        color: Color(0xff2E7998), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    ("fine_fees").tr(),
                    style: GoogleFonts.cairo(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  SvgPicture.asset(
                      'packages/smart_advisor/smart_advisor_assets/images/Cardss.svg')
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              width: 170,
              height: 70,
              decoration: BoxDecoration(
                  border:
                      Border.all(color: Color.fromRGBO(142, 154, 158, 0.096)),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        ("correction_deadline").tr(),
                        style: GoogleFonts.cairo(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SvgPicture.asset(
                          'packages/smart_advisor/smart_advisor_assets/images/Clock.svg')
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    '٧ يوم',
                    style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold, color: Color(0xff656A73)),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: 170,
              height: 70,
              decoration: BoxDecoration(
                  border:
                      Border.all(color: Color.fromRGBO(142, 154, 158, 0.096)),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        ("double_fine").tr(),
                        style: GoogleFonts.cairo(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SvgPicture.asset(
                          'packages/smart_advisor/smart_advisor_assets/images/Cardss.svg')
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    'نعم',
                    style: GoogleFonts.cairo(
                        color: Color(0xff656A73), fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
