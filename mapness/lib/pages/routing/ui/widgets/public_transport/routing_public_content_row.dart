import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';

class RoutingPublicContentRow extends StatelessWidget {
  final String title;
  final Color leadingIconColor;
  final Color? lineColor;
  final String? lineName;
  final EdgeInsetsGeometry? padding;

  const RoutingPublicContentRow({
    required this.title,
    required this.leadingIconColor,
    this.lineColor,
    this.lineName,
    this.padding,
    super.key,
  });

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$2x),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BulletPoint(lineColor: leadingIconColor),
          Spacing.$3x.widthBox,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textStyles.bodyLargeRegular.copyWith(
                  color: context.colors.foregroundDefault,
                  height: 0.8,
                ),
              ),
              if ((lineName?.isNotEmpty ?? false) && (lineColor != null)) ...[
                Spacing.$1x.heightBox,
                Row(
                  children: [
                    if (lineColor != null) ...[
                      Icon(
                        TransportIcons.metroStation,
                        size: 18,
                        color: lineColor,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      lineName ?? '',
                      style: context.textStyles.bodySmallRegular.copyWith(
                        color: context.colors.foregroundSoft,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final Color lineColor;
  const _BulletPoint({required this.lineColor});

  @override
  Widget build(BuildContext context) => Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: lineColor,
          shape: BoxShape.circle,
          boxShadow: Shadows.m,
        ),
      );
}
