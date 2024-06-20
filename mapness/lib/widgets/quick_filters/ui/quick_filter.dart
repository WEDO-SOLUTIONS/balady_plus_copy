import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';

class QuickFilter extends StatelessWidget {
  const QuickFilter({
    required this.item,
    required this.selected,
    super.key,
    this.background = NonThemeColor.color11,
  });

  final FilterItem item;
  final bool selected;
  final Color background;

  @override
  Widget build(BuildContext context) => Material(
        color: selected ? context.color.strokeAccent : background,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: item.onTap,
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
                  if (item.icon != null)
                    SvgPicture.asset(
                      item.icon!,
                      height: 24,
                      width: 24,
                      package: PackageConfig.packageName,
                      colorFilter: ColorFilter.mode(
                        selected ? Colors.white : context.color.textAndIconsBasePrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                  if (item.title != null) ...[
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      item.title!,
                      style: context.textStyle.text.copyWith(
                        color: selected ? Colors.white : context.color.textAndIconsBasePrimary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
}
