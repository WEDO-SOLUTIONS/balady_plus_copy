import 'package:flutter/material.dart';

class FrameActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const FrameActionButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1A1A1A),
          fontSize: 15,
          fontFamily: 'TheSansArab',
          fontWeight: FontWeight.w600,
          letterSpacing: -0.30,
        ),
      ),
    );
  }
}
