import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class MoreFilterChip extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const MoreFilterChip({
    required this.title,
    required this.icon,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: context.colors.accentDefault.withOpacity(.09),
            borderRadius: BorderRadius.circular(RadiusBorder.m),
          ),
          child: Icon(icon, size: 24, color: context.colors.accentDefault),
        ),
        const SizedBox(height: Spacing.$2x),
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: context.textStyles.bodySmallRegular.copyWith(
            color: context.colors.foregroundDefault,
            height: 1.25,
          ),
        ),
      ],
    ),
  );
}
