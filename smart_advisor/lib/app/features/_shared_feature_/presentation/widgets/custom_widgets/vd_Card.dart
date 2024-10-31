import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class VdCard extends StatelessWidget {
  const VdCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        //padding: EdgeInsets.all(16),
        height: 132,
        // width: 363,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          //image: Ass
        ),
        child: SvgPicture.asset(
          'packages/smart_advisor/smart_advisor_assets/images/vd.svg',
          fit: BoxFit.contain,
        ),
      ),
      Container(
        width: 215,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مكتبة التشوه البصري',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "تعرف على أنواع التشوه البصري وطريقة معالجته",
                maxLines: 2,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
