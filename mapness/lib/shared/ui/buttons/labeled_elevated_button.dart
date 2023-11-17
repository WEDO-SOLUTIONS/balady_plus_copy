import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LabeledElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool enabled;
  final String label;

  const LabeledElevatedButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff4CA5B4),
        disabledBackgroundColor: const Color(0xffDDDFE1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        padding: const EdgeInsets.all(10),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 16,
          height: 22 / 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
