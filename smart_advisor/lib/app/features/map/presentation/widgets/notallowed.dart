import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Notallowed extends StatelessWidget {
  const Notallowed({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 33,
      width: 115,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 11, left: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                  color: const Color(0xFFE34736),
                  borderRadius: BorderRadius.circular(6)),
            ),
            Text(
              "غير مسموح",
              style: GoogleFonts.cairo(fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}
