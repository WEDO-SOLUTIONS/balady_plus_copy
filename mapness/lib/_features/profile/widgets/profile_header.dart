import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class ProfileHeader extends ConsumerStatefulWidget {
  const ProfileHeader({super.key, this.onBackPress});
  final VoidCallback? onBackPress;

  @override
  ConsumerState<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends ConsumerState<ProfileHeader> {
  int tapsToGo = 10;

  @override
  Widget build(BuildContext context) {
    final direction = ref.watch(uiDirectionProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: Material(
              borderRadius: BorderRadius.circular(8),
              color: context.color.surface_base_secondary,
              child: InkWell(
                onTap: widget.onBackPress,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    direction == TextDirection.ltr
                        ? 'assets/icons/svg/ic_chevron_left.svg'
                        : 'assets/icons/svg/ic_chevron_right.svg',
                    height: 24,
                    width: 24,
                    package: PackageConfig.packageName,
                    colorFilter: ColorFilter.mode(
                      context.color.text_and_icons_base_primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            context.l10n.profile,
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .textL
                .copyWith(color: context.color.text_and_icons_base_primary),
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
