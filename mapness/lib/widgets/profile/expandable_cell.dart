import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';

class ExpandableCell extends StatelessWidget {
  const ExpandableCell({
    required this.title,
    required this.icon,
    required this.content,
    super.key,
    this.subtitle,
    this.count,
  });

  final String title;
  final String? subtitle;
  final int? count;
  final String icon;
  final Widget content;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: ExpansionWidget(
      titleBuilder: (animationValue, easeInValue, isExpanded, toggleFunction) => Material(
        color: context.colors.backgroundSurface4,
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
                SvgPicture.asset(
                  icon,
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(context.colors.accentDefault, BlendMode.srcIn),
                ),
                const SizedBox(
                  width: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: DefaultTextStyle.of(context).style.copyWith(
                          fontSize: 16,
                          height: 1.4,
                          color: context.colors.foregroundDefault,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          subtitle!,
                          style: context.textStyle.caption.copyWith(color: context.colors.foregroundDefault),
                        ),
                      ],
                    ],
                  ),
                ),
                const Spacer(),
                if (count != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      context.digits('$count'),
                      style: Theme.of(
                        context,
                      ).extension<ThemeTextStyles>()!.text.copyWith(color: context.colors.foregroundDefault),
                    ),
                  ),
                const SizedBox(
                  width: 2,
                ),
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
      ),
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
