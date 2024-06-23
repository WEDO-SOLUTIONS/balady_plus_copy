import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CloseButton extends StatelessWidget {
  const CloseButton({
    required this.onTap,
    super.key,
    this.borderRadius,
  });
  final VoidCallback onTap;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) => Material(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: InkWell(
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              // color: Colors.white,
              color: context.color.surfaceBasePrimary,
            ),
            padding: const EdgeInsets.all(8),
            child: SvgPicture.asset(
              'assets/icons/svg/ic_search_close.svg',
              semanticsLabel: 'MinApps Screen',
              package: 'mapness',
              colorFilter: ColorFilter.mode(
                context.color.textAndIconsBasePrimary.withOpacity(0.7),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      );
}
