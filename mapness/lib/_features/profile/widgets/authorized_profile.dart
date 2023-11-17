import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/shared/config/package_config.dart';

class AuthorizedProfile extends StatelessWidget {
  const AuthorizedProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/svg/ic_nav_profile.svg',
            height: 96,
            width: 96,
            package: PackageConfig.packageName,
            colorFilter: const ColorFilter.mode(
              Color(0xff898e96),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            "Ahmed Abdu Ahmed Avh El Usman",
            style: GoogleFonts.inter(
              fontSize: 21,
              fontWeight: FontWeight.w600,
              height: 1.1,
              color: const Color(0xFF1E2A36),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
