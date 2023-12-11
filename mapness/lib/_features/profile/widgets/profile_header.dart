import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const SizedBox(
            width: 40,
          ),
          const Spacer(),
          Text(
            context.l10n.profile,
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .textL
                .copyWith(color: const Color(0xFF1E2A36)),
          ),
          const Spacer(),
          SizedBox(
            height: 40,
            width: 40,
            child: Material(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFF5F7FA),
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
                      Color(0xFF1E2A36),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
