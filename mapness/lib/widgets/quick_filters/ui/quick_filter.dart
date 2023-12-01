import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';

class QuickFilter extends StatelessWidget {
  const QuickFilter({
    super.key,
    required this.item,
    required this.selected,
    required this.onTap,
    this.background = const Color(0x0D1E2A36),
  });

  final FilterItem item;
  final bool selected;
  final Function() onTap;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFF1E2A36) : background,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 52),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 9,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  item.icon,
                  height: 24,
                  width: 24,
                  package: PackageConfig.packageName,
                  colorFilter: ColorFilter.mode(
                    selected ? Colors.white : const Color(0xFF1E2A36),
                    BlendMode.srcIn,
                  ),
                ),
                if (item.title != null) ...[
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    item.title!,
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .textM
                        .copyWith(
                          color:
                              selected ? Colors.white : const Color(0xFF1E2A36),
                        ),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
