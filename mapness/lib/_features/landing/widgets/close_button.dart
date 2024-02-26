import 'package:balady_uikit/colors/non_theme_colors.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class CloseButton extends StatelessWidget {
  const CloseButton({required this.onTap, super.key});

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.color.surface_base_primary,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: SvgPicture.asset(
          'assets/icons/svg/ic_close.svg',
          semanticsLabel: 'MinApps Screen',
          package: 'mapness',
          colorFilter: const ColorFilter.mode(
            NonThemeColor.color49,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
