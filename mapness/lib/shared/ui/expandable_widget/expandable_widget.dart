import 'dart:math';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';

class ExpandableWidget extends StatelessWidget {
  const ExpandableWidget({
    required this.title,
    required this.icon,
    required this.content,
    super.key,
    this.subtitle,
  });

  final Widget title;
  final String? subtitle;
  final Widget icon;
  final Widget content;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: ExpansionWidget(
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
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                  ),
                  child: Row(
                    children: [
                      icon,
                      const SizedBox(
                        width: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
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
                                style: context.textStyle.caption.copyWith(
                                  color: context.color.textAndIconsBasePrimary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const Spacer(),
                      Transform.rotate(
                        angle: pi * animationValue,
                        child: SvgPicture.asset(
                          Assets.icons.svg.icChevronDown.keyName,
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          content: Container(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
            ),
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
