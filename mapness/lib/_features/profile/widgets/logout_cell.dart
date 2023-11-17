import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/config/package_config.dart';

class LogoutCell extends ConsumerWidget {
  const LogoutCell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 12,
              bottom: 14,
              right: 16,
            ),
            child: Row(
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    "Log out",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      height: 1.4,
                      color: const Color(0xFF1E2A36),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                SvgPicture.asset(
                  "assets/icons/svg/ic_profile_logout.svg",
                  height: 24,
                  width: 24,
                  package: PackageConfig.packageName,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
