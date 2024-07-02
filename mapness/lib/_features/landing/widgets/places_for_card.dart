import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class PlacesForCart extends ConsumerWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const PlacesForCart({
    required this.title,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => ClipRRect(
        borderRadius: BorderRadius.circular(RadiusBorder.xl),
        child: GestureDetector(
          onTap: onTap,
          child: ColoredBox(
            color: context.colorsV2.backgroundSurface1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: Spacing.$4x, start: Spacing.$4x),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: context.isLTR ? Matrix4.identity() : Matrix4.rotationY(pi),
                    child: Icon(
                      icon,
                      size: 32,
                      color: context.colorsV2.accentDefault,
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.$4x),
                Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: Spacing.$4x, start: Spacing.$4x),
                  child: Text(title, style: context.textStyleV3.bodyLargeMedium),
                ),
              ],
            ),
          ),
        ),
      );
}
