import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IwishActionIconButton extends StatelessWidget {
  const IwishActionIconButton({
    required this.iconAsset,
    required this.onPressed,
    super.key,
  });
  final String iconAsset;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Material(
        color: context.color.surfaceBasePrimary,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            child: SvgPicture.asset(
              iconAsset,
            ),
          ),
        ),
      );
}
