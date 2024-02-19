import 'package:balady_uikit/colors/non_theme_colors.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';


class PathNavSettingToggle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool state;
  final void Function(bool)? onChanged;

  const PathNavSettingToggle({
    super.key,
    required this.title,
    this.subtitle,
    required this.state,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  style: Theme.of(context).extension<ThemeTextStyles>()!.textM
                      .copyWith(
                      color: context.color.text_and_icons_base_primary),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: Theme.of(context).extension<ThemeTextStyles>()!.textM.copyWith(color: NonThemeColor.color16),
                  ),
                ]
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
}
