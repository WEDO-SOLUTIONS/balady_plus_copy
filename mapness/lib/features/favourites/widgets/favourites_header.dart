import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/features/common/config/package_config.dart';

class FavouritesHeader extends StatelessWidget {
  const FavouritesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 16.0, right: 16.0),
      child: Row(
        children: [
          Material(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0x0D1E2A36),
            child: InkWell(
              onTap: () {
                StatefulNavigationShell.of(context).goBranch(3);
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(
                  'assets/icons/svg/ic_chevron_right.svg',
                  height: 24,
                  width: 24,
                  package: PackageConfig.packageName,
                  colorFilter: const ColorFilter.mode(
                    Color(0xB21E2A36),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            "Favorites",
            style: GoogleFonts.inter(
              fontSize: 18,
              height: 1.4,
              color: const Color(0xFF1E2A36),
            ),
          ),
          const Spacer(),
          const SizedBox(
            width: 40,
          ),
        ],
      ),
    );
  }
}
