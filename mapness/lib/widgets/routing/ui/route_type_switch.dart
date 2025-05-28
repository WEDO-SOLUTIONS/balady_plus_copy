import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';

class RouteTypeSwitch extends ConsumerWidget {
  const RouteTypeSwitch({
    required this.onPressed,
    required this.title,
    required this.iconAsset,
    required this.isChoosed,
    super.key,
  });
  final VoidCallback onPressed;
  final String? title;
  final String iconAsset;
  final bool isChoosed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleColor = isChoosed ? context.color.textAndIconsBasePrimary : NonThemeColor.color16;

    return Directionality(
      textDirection: ref.watch(uiDirectionProvider),
      child: Material(
        color: isChoosed ? NonThemeColor.color11 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 12,
              top: 6,
              bottom: 6,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  iconAsset,
                  height: 30,
                  colorFilter: ColorFilter.mode(
                    titleColor,
                    BlendMode.srcATop,
                  ),
                ),
                if (title != null) ...[
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    title!,
                    style: context.textStyle.footNoteBold.copyWith(
                      color: titleColor,
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
}
