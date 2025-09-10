import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';

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
                  boxShadow: Shadows.s,
                  image: DecorationImage(
                    image: Assets.images.exploreMbc.provider(),
                    matchTextDirection: true,
                    fit: BoxFit.cover,
                    alignment: AlignmentDirectional.centerEnd,
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                            top: 12.0, start: 16.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Explore the', // context.l10n.driveBack,
                            style: context.textStyles.h3Medium.copyWith(
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(
                                text: '\nmedia catalog',
                                style: context.textStyles.h3Medium.copyWith(
                                  color: const Color(0xFF00FFFA),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                          bottom: 12.0,
                          start: 16.0,
                        ),
                        child: Row(
                          children: [
                            Assets.icons.svg.icMbcMood.svg(),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              'MBC MOOD',
                              style:
                                  context.textStyles.bodyLargeSemiBold.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.all(Spacing.$4x),
                        child: SizedBox(
                          width: Spacing.$6x,
                          height: Spacing.$6x,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Spacing.$1_5x),
                              color:
                                  context.colors.staticWhite.withOpacity(0.2),
                            ),
                            child: Center(
                              child: Icon(
                                SystemIcons.arrowRight,
                                color: context.colors.staticWhite,
                                size: Spacing.$5x,
                              ),
                            ),
                          ),
                        ),
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
