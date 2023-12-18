import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_features.dart';

class ProfileHeader extends ConsumerStatefulWidget {
  final VoidCallback? onBackPress;
  const ProfileHeader({super.key, this.onBackPress});

  @override
  ConsumerState<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends ConsumerState<ProfileHeader> {
  int tapsToGo = 10;

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
          InkWell(
            onTap: () {
              setState(() {
                tapsToGo -= 1;
              });
              if (tapsToGo == 0) {
                ref.read(appFeaturesProvider.notifier).enableNavi();
              }
            },
            child: Text(
              context.l10n.profile,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .textL
                  .copyWith(color: const Color(0xFF1E2A36)),
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 40,
            width: 40,
            child: Material(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFF5F7FA),
              child: InkWell(
                onTap: widget.onBackPress,
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
