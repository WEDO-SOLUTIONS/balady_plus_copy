import 'package:flutter/material.dart';
import 'package:mapness/shared/config/package_fonts.dart';

class RoutingHistoryEmpty extends StatelessWidget {
  const RoutingHistoryEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          child: Text(
            "Select your starting and destination points, and we will show you convenient routes",
            textAlign: TextAlign.center,
            style: PackageFonts.frutigerArabic(
              color: const Color(0xFF1E2A36),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
