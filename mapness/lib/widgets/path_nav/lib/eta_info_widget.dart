import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EtaInfoWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  const EtaInfoWidget({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: 65,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title ?? '-',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: const Color(0xFF1D2A36),
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              subtitle ?? '-',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: const Color(0x7F1E2A36),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
