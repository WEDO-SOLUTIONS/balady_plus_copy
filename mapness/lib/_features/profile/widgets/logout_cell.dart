import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mapness/shared/extensions/build_context_ext.dart';

import '../../../shared/config/package_config.dart';

class LogoutCell extends ConsumerWidget {
  final VoidCallback? onTap;
  const LogoutCell({
    super.key,
    this.onTap,
  });

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
          onTap: onTap,
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
                    context.l10n.logOut,
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .textM
                        .copyWith(color: const Color(0xFF1E2A36)),
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
