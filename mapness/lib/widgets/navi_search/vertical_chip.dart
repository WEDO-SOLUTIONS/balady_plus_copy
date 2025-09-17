import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class VerticalChip extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const VerticalChip({required this.title, required this.icon, this.onTap, super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 94,
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$2x, vertical: Spacing.$3x),
          decoration: BoxDecoration(
            color: context.colors.accentSecondaryContainerSoft.withOpacity(.05),
            borderRadius: BorderRadius.circular(RadiusBorder.m),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 24,
                color: context.colors.accentSecondaryDefault,
              ),
              const SizedBox(height: Spacing.$1x),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: context.textStyles.bodySmallMedium.copyWith(color: context.colors.accentSecondaryDefault),
              ),
            ],
          ),
        ),
      );
}
