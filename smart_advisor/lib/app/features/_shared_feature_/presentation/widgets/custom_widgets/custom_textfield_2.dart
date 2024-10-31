import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextfield2 extends StatelessWidget {
  const CustomTextfield2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),

      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: TextField(
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'ابحث عن منشاه ...',
            hintStyle: GoogleFonts.cairo(),
            labelStyle: GoogleFonts.cairo(
              color: const Color(0xFF8E8E93),
            )
            // fontWeight: FontWeight.bold,
            //  errorText: 'Username is required',
            ),
      ),
      //Padding(padding: EdgeInsets.symmetric(vertical: 8)),
    );
  }
}
