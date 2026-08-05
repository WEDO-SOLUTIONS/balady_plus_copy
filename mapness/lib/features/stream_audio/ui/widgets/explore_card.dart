import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/stream_audio/ui/widgets/mbc_mood.dart';

class ExploreCard extends ConsumerStatefulWidget {
  const ExploreCard({super.key});

  @override
  ConsumerState<ExploreCard> createState() => _ExploreCardState();
}

class _ExploreCardState extends ConsumerState<ExploreCard> {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        child: GestureDetector(
          onTap: () => context.router.push(const MediaCatalogRoute()),
          child: SizedBox(
            width: double.infinity,
            height: 123,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(RadiusBorder.xl),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(RadiusBorder.xl),
                  color: const Color(0xFF005937),
                ),
                child: Stack(
                  children: [
                    Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: CommonFunctions.isAppAR
                            ? Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(math.pi),
                                child: Assets.images.exploreMbc.image())
                            : Assets.images.exploreMbc.image()),
                    // Explore text
                    _buildExploreText(),

                    // MBC Mood
                    _buildMBCMood(),

                    // Arrow right
                    _buildArrowRight(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildExploreText() => Align(
        alignment: AlignmentDirectional.topStart,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(top: 12.0, start: 16.0),
          child: RichText(
            text: TextSpan(
              text: Directionality.of(context) == TextDirection.rtl ? 'استكشِف' : 'Explore the',
              style: context.textStyles.h3Medium.copyWith(
                color: Colors.white,
              ),
              children: [
                TextSpan(
                  text: Directionality.of(context) == TextDirection.rtl ? '\nكتالوج الوسائط' : '\nmedia catalog',
                  style: context.textStyles.h3Medium.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildMBCMood() => const Align(
        alignment: AlignmentDirectional.bottomStart,
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            bottom: 12.0,
            start: 16.0,
          ),
          child: MBCMood(),
        ),
      );

  Widget _buildArrowRight() => Align(
        alignment: AlignmentDirectional.topEnd,
        child: Padding(
          padding: const EdgeInsetsDirectional.all(Spacing.$4x),
          child: SizedBox(
            width: Spacing.$6x,
            height: Spacing.$6x,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Spacing.$1_5x),
                color: context.colors.staticWhite,
              ),
              child: Center(
                child: Icon(
                  SystemIcons.arrowCornerRightLarge,
                  color: context.colors.staticBlack,
                  size: Spacing.$4x,
                ),
              ),
            ),
          ),
        ),
      );
}
