import 'package:balady_uikit/colors/non_theme_colors.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/favourites/widgets/screen/delete_icon.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class PinnedPlaceWidget extends StatelessWidget {
  const PinnedPlaceWidget({
    required this.address,
    required this.iconAsset,
    required this.title,
    required super.key,
    required this.onTap,
    required this.isEditing,
    required this.onDelete,
    required this.isAdded,
  });
  final String iconAsset;
  final String title;
  final String address;
  final bool isAdded;
  final bool isEditing;
  final VoidCallback? onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Dismissible(
        direction:
            isAdded ? DismissDirection.horizontal : DismissDirection.none,
        onDismissed: (_) => onDelete(),
        background: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: NonThemeColor.color57,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.filled(
              2,
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                child: Text(
                  context.l10n.delete,
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .textS
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        key: key!,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: context.color.surface_base_primary,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  if (isEditing) DeleteIcon(onPressed: onDelete),
                  if (isEditing) const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.right,
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()!
                              .textL
                              .copyWith(
                                  color: context
                                      .color.text_and_icons_base_primary),
                        ),
                        Text(
                          address,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()!
                              .textS
                              .copyWith(
                                color: isAdded
                                    ? context.color.stroke_accent
                                    : NonThemeColor.color34,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: context.color.surface_base_primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        iconAsset,
                        colorFilter: ColorFilter.mode(
                          context.color.stroke_accent,
                          BlendMode.srcATop,
                        ),
                        package: PackageConfig.packageName,
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
