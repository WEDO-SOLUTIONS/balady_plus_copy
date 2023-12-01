import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mapness/_features/favourites/widgets/screen/delete_icon.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

import '../../../../shared/config/package_config.dart';

class PinnedPlaceWidget extends StatelessWidget {
  final String iconAsset;
  final String title;
  final String address;
  final bool isAdded;
  final bool isEditing;
  final VoidCallback? onTap;
  final VoidCallback onDelete;

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

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: isAdded ? DismissDirection.horizontal : DismissDirection.none,
      onDismissed: (_) => onDelete(),
      background: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xfff4383c),
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
          color: const Color(0xffEDF6F7),
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
                            .copyWith(color: const Color(0xFF1D2A36)),
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
                                    ? const Color(0xFF4CA5B4)
                                    : const Color(0xF2285A5B)),
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
                  decoration: const BoxDecoration(
                    color: Color(0xffe5eef1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      iconAsset,
                      colorFilter: const ColorFilter.mode(
                        Color(0xff4CA5B4),
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
}
