import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';

class JobButton extends StatelessWidget {
  const JobButton({
    required this.label,
    required this.asset,
    super.key,
    this.backgroundColor,
    this.textColor,
    this.enabled = true,
    this.onPressed,
  });
  final String label;
  final String asset;
  final Color? backgroundColor;
  final Color? textColor;
  final bool enabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? context.color.strokeAccent,
          disabledBackgroundColor: context.color.surfaceBasePrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          padding: const EdgeInsets.all(10),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              asset,
              height: 18,
              width: 18,
              colorFilter: ColorFilter.mode(
                textColor ?? Colors.white,
                BlendMode.srcIn,
              ),
              package: PackageConfig.packageName,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: context.textStyle.text.copyWith(color: textColor ?? Colors.white),
            ),
          ],
        ),
      );
}
