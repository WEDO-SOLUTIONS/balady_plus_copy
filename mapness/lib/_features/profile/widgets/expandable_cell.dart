import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'dart:math';

import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import '../../../shared/config/package_config.dart';

class ExpandableCell extends StatelessWidget {
  const ExpandableCell({
    super.key,
    required this.title,
    this.subtitle,
    this.count,
    required this.icon,
    required this.content,
  });

  final String title;
  final String? subtitle;
  final int? count;
  final String icon;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ExpansionWidget(
        titleBuilder:
            (animationValue, easeInValue, isExpanded, toggleFunction) {
          return Material(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(8),
              topRight: const Radius.circular(8),
              bottomLeft: Radius.circular(isExpanded ? 0 : 8),
              bottomRight: Radius.circular(isExpanded ? 0 : 8),
            ),
            child: InkWell(
              onTap: () => toggleFunction(animated: true),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(8),
                topRight: const Radius.circular(8),
                bottomLeft: Radius.circular(isExpanded ? 0 : 8),
                bottomRight: Radius.circular(isExpanded ? 0 : 8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Transform.rotate(
                      angle: pi * animationValue,
                      child: SvgPicture.asset(
                        "assets/icons/svg/ic_chevron_down.svg",
                        height: 24,
                        width: 24,
                        package: PackageConfig.packageName,
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    if (count != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: Text(
                          "$count",
                          style: Theme.of(context).extension<ThemeTextStyles>()!.textM.copyWith(color: const Color(0xFF1E2A36)),
                        ),
                      ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            title,
                            style: DefaultTextStyle.of(context).style.copyWith(
                                  fontSize: 16,
                                  height: 1.4,
                                  color: const Color(0xFF1E2A36),
                                ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              subtitle!,
                              style: Theme.of(context).extension<ThemeTextStyles>()!.textXS.copyWith(color: const Color(0xB21E2A36)),
                            ),
                          ]
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    SvgPicture.asset(
                      icon,
                      height: 24,
                      width: 24,
                      package: PackageConfig.packageName,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        content: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: content,
        ),
      ),
    );
  }
}
