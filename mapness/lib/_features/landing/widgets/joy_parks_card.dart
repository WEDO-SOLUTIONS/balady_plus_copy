import 'dart:math';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class JoyParksCard extends ConsumerWidget {
  const JoyParksCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: GestureDetector(
            onTap: ref.read(layersControlsProvider.notifier).toggleJoyParks,
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
                      padding: const EdgeInsets.only(left: 25, top: 27, right: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.l10n.joyParks,
                            style: context.textStyleV3.h4SemiBold.copyWith(
                              color: context.colorsV2.staticWhite,
                            ),
                          ),
                          Text(
                            context.l10n.exploreNature,
                            style: context.textStyleV3.captionLargeRegular.copyWith(
                              color: context.colorsV2.staticWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Transform(
                      alignment: Alignment.center,
                      transform: context.isLTR ? Matrix4.identity() : Matrix4.rotationY(pi),
                      child: Image.asset(
                        'assets/images/tree-and-park-bench-white-background.png',
                        package: PackageConfig.packageName,
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
