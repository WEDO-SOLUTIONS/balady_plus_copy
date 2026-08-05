import 'package:flutter/material.dart';

//!
class PersonaBanner extends StatelessWidget {
  const PersonaBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadows: [
          BoxShadow(color: Color(0x14000000), blurRadius: 4, offset: Offset(0, 1), spreadRadius: 0),
          BoxShadow(color: Color(0x0A000000), blurRadius: 0, offset: Offset(0, 0), spreadRadius: 0.50),
        ],
      ),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              spacing: 6,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Persona Banner Section',
                  style: TextStyle(
                    color: const Color(0xFF1B1B1B),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.50,
                  ),
                ),
                Text(
                  'persona_banner_subtitle',
                  style: TextStyle(
                    color: const Color(0xFF4C4C4C),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
