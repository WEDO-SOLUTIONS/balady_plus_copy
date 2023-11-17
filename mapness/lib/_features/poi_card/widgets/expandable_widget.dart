import 'dart:math';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/shared/config/package_config.dart';

class ExpandableWidget extends StatelessWidget {
  const ExpandableWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.content,
  });

  final Widget title;
  final String? subtitle;
  final Widget icon;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return ExpansionWidget(
      titleBuilder: (
        animationValue,
        easeInValue,
        isExpanded,
        toggleFunction,
      ) {
        final borderRadius = BorderRadius.only(
          topLeft: const Radius.circular(8),
          topRight: const Radius.circular(8),
          bottomLeft: Radius.circular(isExpanded ? 0 : 8),
          bottomRight: Radius.circular(isExpanded ? 0 : 8),
        );
        return Material(
          color: Colors.white,
          borderRadius: borderRadius,
          child: InkWell(
            onTap: () => toggleFunction(animated: true),
            borderRadius: borderRadius,
            child: Row(
              children: [
                icon,
                const SizedBox(
                  width: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      title,
                      if (subtitle != null) ...[
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          subtitle!,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xB21E2A36),
                            height: 1.4,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
                const Spacer(),
                Transform.rotate(
                  angle: pi * animationValue,
                  child: SvgPicture.asset(
                    "assets/icons/svg/ic_chevron_down.svg",
                    height: 24,
                    width: 24,
                    package: PackageConfig.packageName,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      content: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: content,
      ),
    );
  }
}
