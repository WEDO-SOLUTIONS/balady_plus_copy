import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/shared/config/package_config.dart';

class MiniAppHeader extends ConsumerWidget {
  const MiniAppHeader({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final direction = ref.watch(uiDirectionProvider);

    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 8,
        ),
        child: Row(
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: Material(
                borderRadius: BorderRadius.circular(8),
                color: context.color.surfaceBaseSecondary,
                child: InkWell(
                  onTap: () {
                    context.pop();
                  },
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
                        context.color.textAndIconsBasePrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .heading2
                  .copyWith(color: context.color.textAndIconsBasePrimary),
            ),
            const Spacer(),
            const SizedBox(
              width: 40,
            ),
          ],
        ),
      ),
    );
  }
}
