import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:sheetify/sheetify.dart';

class JoyParksCardV2 extends ConsumerWidget {
  final MultiStateSheetController controller;

  const JoyParksCardV2({required this.controller, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(RadiusBorder.xl),
          child: GestureDetector(
            onTap: () {
              controller.setState(ThreeStateSheet.hidden);

              // ref.read(layersControlsProvider.notifier).toggleIwish();
            },
            child: SizedBox(
              height: 118,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF9DC96C), Color(0xFF6FA03B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(top: 27, start: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.l10n.joyParks,
                            style: context.textStyles.h4SemiBold.copyWith(
                              color: context.colors.staticWhite,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.l10n.exploreNature,
                            style: context.textStyles.captionLargeRegular.copyWith(
                              color: context.colors.staticWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Transform(
                      alignment: Alignment.center,
                      transform: context.isLTR ? Matrix4.identity() : Matrix4.rotationY(pi),
                      child: Image.asset(
                        Assets.images.treeAndParkBenchWhiteBackground.keyName,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
