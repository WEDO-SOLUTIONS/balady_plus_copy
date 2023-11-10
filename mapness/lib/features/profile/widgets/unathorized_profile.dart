import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/features/common/config/package_config.dart';

class UnautorizedProfile extends StatelessWidget {
  const UnautorizedProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 248,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          SvgPicture.asset(
            'assets/images_svg/profile_background.svg',
            package: PackageConfig.packageName,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              top: 35,
              bottom: 43,
            ),
            child: Column(
              children: [
                const SizedBox(
                  width: 95,
                  height: 40,
                  child: Image(
                    image: AssetImage(
                      'assets/images/balady_logo.png',
                      package: PackageConfig.packageName,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Sign in to unlock the full potential\nof the Balady app',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF1E2A36),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Material(
                  color: const Color(0xFF4CA5B4),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 13,
                        right: 13,
                        top: 9,
                        bottom: 12,
                      ),
                      child: Center(
                        child: Text(
                          'Connect to Momrah',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
