import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/core/utils/constants/paths/icon_paths.dart';

class LocationFieldWidget extends StatelessWidget {
  const LocationFieldWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("الموقع",
                textAlign: TextAlign.start,
                style: GoogleFonts.cairo(
                  color: const Color(0xFF1A1A1A),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          height: 52,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: const Color(0xffFFFFFF),
              border: Border.all(color: const Color(0xffEAEAEE)),
              borderRadius: const BorderRadius.all(Radius.circular(9))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("84849 حي العليا ، الرياض",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.cairo(
                    color: const Color(0xFF17263D),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  )),
              RotatedBox(
                  quarterTurns: 1, child: SvgPicture.asset(IconPath.arraowDawn))
            ],
          ),
        ),
      ],
    );
  }
}
