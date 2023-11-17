import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/shared/config/package_config.dart';

class EmptyResultWidget extends StatelessWidget {
  final String text;
  const EmptyResultWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset('assets/images_svg/empty_search.svg',
            package: PackageConfig.packageName,
            width: 240,
            height: 140,
            fit: BoxFit.contain,
            alignment: Alignment.center),
        const SizedBox(height: 10),
        Text(
          text,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: const Color(0xFF1D2A36),
            fontSize: 18,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.18,
          ),
        ),
      ],
    );
  }
}
