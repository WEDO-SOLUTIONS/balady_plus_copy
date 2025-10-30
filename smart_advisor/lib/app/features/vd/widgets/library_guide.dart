import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/core/utils/constants/paths/icon_paths.dart';

class LibraryGuide extends StatelessWidget {
  const LibraryGuide({super.key});
//DELETE this page
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 114,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            color: Colors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'packages/smart_advisor/smart_advisor_assets/images/buldings.png',
                height: 55,
                width: 55,
              ),
              SizedBox(
                width: 7,
              ),
              //SvgPicture.asset('assetName'),
              Padding(
                padding: const EdgeInsets.only(top: 17),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'البناء تحت الانشاء ',
                      style: GoogleFonts.cairo(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('تعرف علي المخالفات وبنود التفتيش للمباني',
                        maxLines: 2,
                        style: GoogleFonts.cairo(
                            fontSize: 14, color: Color(0xFF6F7B80))),
                  ],
                ),
              ),
              // Text('data'),
              SvgPicture.asset(IconPath.arrowRight)
            ],
          ),
        ),
      ],
    );
  }
}
