import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/shared/config/package_config.dart';

class RouteTypeSwitch extends ConsumerWidget {
  final VoidCallback onPressed;
  final String? title;
  final String iconAsset;
  final bool isChoosed;

  const RouteTypeSwitch({
    required this.onPressed,
    required this.title,
    required this.iconAsset,
    required this.isChoosed,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleColor =
        isChoosed ? const Color(0xff1E2A36) : const Color(0xff8E949A);

    return Directionality(
      textDirection: ref.watch(uiDirectionProvider),
      child: Material(
        color: isChoosed ? const Color(0x0D1E2A36) : Colors.transparent,
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
                  package: PackageConfig.packageName,
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
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .accentS
                        .copyWith(
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
