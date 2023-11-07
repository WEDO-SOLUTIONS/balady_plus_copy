import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/features/common/config/package_config.dart';

class FavouritesHeader extends StatelessWidget {
  const FavouritesHeader({
    super.key,
    required this.isEditing,
    required this.onEditTap,
    required this.onDoneTap,
    required this.onDeleteAllTap,
  });

  final bool isEditing;
  final void Function() onEditTap;
  final void Function() onDoneTap;
  final void Function() onDeleteAllTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 16.0, right: 16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            "Favorites",
            style: GoogleFonts.inter(
              fontSize: 18,
              height: 1.4,
              color: const Color(0xFF1E2A36),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            children: [
              isEditing
                  ? GestureDetector(
                      onTap: onDeleteAllTap,
                      child: Text(
                        "Delete all",
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                          color: const Color(0xFF1E2A36),
                        ),
                      ),
                    )
                  : Material(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0x0D1E2A36),
                      child: InkWell(
                        onTap: () {
                          context.pop();
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
              GestureDetector(
                onTap: isEditing ? onEditTap : onDoneTap,
                child: Text(
                  isEditing ? "Done" : "Edit",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                    color: const Color(0xFF1E2A36),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
