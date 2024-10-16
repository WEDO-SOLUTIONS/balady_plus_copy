import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalculatorItem extends StatelessWidget {
  final String title;
  final String subTitle;
  const CalculatorItem(
      {super.key, required this.subTitle, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: const Color(0xffFFFFFF),
          border: Border.all(color: const Color(0xffEAEAEE)),
          borderRadius: const BorderRadius.all(Radius.circular(9))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              textAlign: TextAlign.start,
              style: GoogleFonts.cairo(
                color: const Color(0xFF17263D),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              )),
          Row(
            children: [
              Text(subTitle,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.cairo(
                    color: const Color(0xFF000000),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(
                width: 4,
              ),
              Text("ريال",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.cairo(
                    color: const Color(0xFF17263D),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
