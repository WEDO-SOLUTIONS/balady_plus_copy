import 'package:flutter/material.dart';

class TextItem extends StatelessWidget {
  final String name;
  final double size;
  final String desc;
  const TextItem(
      {super.key, required this.name, required this.desc, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              color: const Color(0xFF145E75),
              fontSize: size,
              fontFamily: 'ArabicUIText',
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            desc,
            style: const TextStyle(
              color: Color(0xFF52525B),
              fontSize: 14,
              fontFamily: 'ArabicUIText',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
