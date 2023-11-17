import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingSheet extends StatelessWidget {
  final String text;
  const LoadingSheet({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        height: 265,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              text,
              style: GoogleFonts.inter(
                color: const Color(0xB21E2A36),
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
