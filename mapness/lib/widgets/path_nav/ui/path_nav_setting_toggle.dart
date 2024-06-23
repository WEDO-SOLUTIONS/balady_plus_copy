import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PathNavSettingToggle extends StatelessWidget {
  const PathNavSettingToggle({
    required this.title,
    required this.state,
    required this.onChanged,
    super.key,
    this.subtitle,
  });
  final String title;
  final String? subtitle;
  final bool state;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textStyle.text.copyWith(
                      color: context.color.textAndIconsBasePrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: context.textStyle.text.copyWith(color: NonThemeColor.color16),
                    ),
                  ],
                ],
              ),
            ),
            CupertinoSwitch(
              value: state,
              onChanged: onChanged,
            ),
          ],
        ),
      );
}
