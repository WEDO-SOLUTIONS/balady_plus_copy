import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppCloseButton extends StatelessWidget {
  const AppCloseButton({required this.onPressed, super.key});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Material(
        child: Ink(
          decoration: BoxDecoration(
            color: context.color.surfaceBasePrimary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onPressed,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.close,
                color: NonThemeColor.color58,
              ),
            ),
          ),
        ),
      );
}

class CustomCloseButton extends StatelessWidget {
  const CustomCloseButton({super.key, this.onClose});

  final Function()? onClose;
  static const borderRadius = BorderRadius.all(Radius.circular(8));

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Material(
          borderRadius: borderRadius,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: onClose,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                color: context.color.textAndIconsBasePrimary.withAlpha(10),
              ),
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(
                'assets/icons/svg/ic_search_close.svg',
                semanticsLabel: 'MinApps Screen',
                package: 'mapness',
                color: context.color.textAndIconsBasePrimary.withOpacity(0.7),
              ),
            ),
          ),
        ),
      );
}
