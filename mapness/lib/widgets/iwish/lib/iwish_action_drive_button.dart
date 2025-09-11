import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';

class IwishActionDriveButton extends StatelessWidget {
  const IwishActionDriveButton({
    required this.label,
    super.key,
    this.onPressed,
  });
  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) => Material(
        color: context.colors.accentOnContainer,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 13),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  Assets.icons.svg.icCar.keyName,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: context.textStyle.text.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );
}
