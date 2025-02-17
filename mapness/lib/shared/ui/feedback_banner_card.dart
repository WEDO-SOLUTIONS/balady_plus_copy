import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class FeedbackBannerCard extends StatelessWidget {
  final String title;
  final String imageAssetName;
  final String? subtitle;
  final List<Color> gradientColors;
  final VoidCallback? onTap;

  const FeedbackBannerCard({
    required this.imageAssetName,
    required this.gradientColors,
    required this.title,
    this.subtitle,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(Spacing.$4x).copyWith(bottom: Spacing.$2x),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.xl)),
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      top: Spacing.$3x,
                      bottom: Spacing.$4x,
                      start: Spacing.$4x,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: context.textStyleV3.h4SemiBold.copyWith(color: context.colorsV3.staticWhite),
                        ),
                        const SizedBox(height: Spacing.$1x),
                        Text(
                          subtitle ?? '',
                          style: context.textStyleV3.captionSmallMedium.copyWith(color: context.colorsV3.staticWhite),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: context.isLTR ? Matrix4.identity() : Matrix4.rotationY(pi),
                          child: Image.asset(
                            'packages/mapness/assets/images/$imageAssetName',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned.directional(
                        textDirection: Directionality.of(context),
                        bottom: 0,
                        end: 0,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(end: Spacing.$4x, bottom: Spacing.$4x),
                          child: SizedBox(
                            width: Spacing.$6x,
                            height: Spacing.$6x,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Spacing.$1_5x),
                                color: context.colorsV3.staticWhite.withOpacity(0.2),
                              ),
                              child: Center(
                                child: Icon(
                                  context.isLTR ? SystemIcons.arrowRight : SystemIcons.arrowLeft,
                                  color: context.colorsV3.staticWhite,
                                  size: Spacing.$5x,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
