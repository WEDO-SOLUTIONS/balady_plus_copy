import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Tag extends StatelessWidget {
  final String text;
  final int currentIndex;
  final int index;
  final Function onPress;

  const Tag(
      {super.key,
      required this.text,
      required this.currentIndex,
      required this.index,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPress(),
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: index == currentIndex ? const Color(0xFF2E7998) : Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 12, left: 12, top: 4),
          child: Text(
            text,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: index == currentIndex
                  ? Colors.white
                  : const Color(0xFF1A202C),
            ),
          ),
        ),
      ),
    );
  }
}
