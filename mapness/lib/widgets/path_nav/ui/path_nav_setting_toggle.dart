import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/config/package_fonts.dart';

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
                  style: PackageFonts.frutigerArabic(
                    color: const Color(0xFF1D2A36),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: PackageFonts.frutigerArabic(
                      color: const Color(0xff8E949A),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
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
