import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

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
            context.l10n.favourites,
            style: Theme.of(context).extension<ThemeTextStyles>()!.textL.copyWith(color: context.color.text_and_icons_base_primary),
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
                        context.l10n.deleteAll,
                        style: Theme.of(context).extension<ThemeTextStyles>()!.textL.copyWith(color: context.color.text_and_icons_base_primary),
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
                            colorFilter: ColorFilter.mode(
                              context.color.text_and_icons_base_primary,
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
                  isEditing ? context.l10n.done : context.l10n.edit,
                  style: Theme.of(context).extension<ThemeTextStyles>()!.textL.copyWith(color: context.color.text_and_icons_base_primary),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
