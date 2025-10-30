// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AreaField extends StatelessWidget {
  const AreaField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("المساحة",
                textAlign: TextAlign.start,
                style: GoogleFonts.cairo(
                  color: Color(0xFF1A1A1A),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffEAEAEE), width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(9.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff155F75), width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(9.0)),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffEAEAEE), width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(9.0)),
            ),
            suffixText: "متر مربع",
            hintText: '30',
            fillColor: Colors.white,

            // You can add more InputDecoration properties as needed
          ),
        )
      ],
    );
  }
}
