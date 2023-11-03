import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/features/common/config/package_config.dart';

class FavouriteTextField extends StatelessWidget {
  const FavouriteTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.right,
      decoration: InputDecoration(
          isDense: true,
          hintStyle: GoogleFonts.inter(
            color: const Color(0x7F2A578A),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 0.09,
            letterSpacing: 0.16,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          hintText: 'Search',
          suffixIconConstraints:
              const BoxConstraints(maxHeight: 24, maxWidth: 24 + 8),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SvgPicture.asset(
              'assets/icons/svg/ic_suggest_search.svg',
              package: PackageConfig.packageName,
            ),
          )),
    );
  }
}
