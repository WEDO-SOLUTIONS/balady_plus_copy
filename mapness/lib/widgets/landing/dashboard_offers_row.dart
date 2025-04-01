import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/scroll/no_glowing_scroll_behavior.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/saudi_pass/offers_group.dart';
import 'package:mapness/features/saudi_pass/providers/offers_screen_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class DashboardOffersRow extends ConsumerWidget {
  const DashboardOffersRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        children: [
          GestureDetector(
            onTap: () {
              context.router.push(
                OffersScreenRoute(offersScreenNotifier: ref.watch(offersScreenRiverpodProvider())),
              );
            },
            child: Row(
              children: [
                const SizedBox(width: 16),
                Text(
                  context.l10n.allOffers,
                  style: context.textStyleV3.h3SemiBold.copyWith(color: context.colorsV3.foregroundDefault),
                ),
                const SizedBox(width: 4),
                AppIcons(
                  iconData: SystemIcons.arrowCornerRightLarge,
                  color: context.colorsV3.foregroundDefault,
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: _DashboardOffersCard.height,
            child: ScrollConfiguration(
              behavior: NoGlowingScrollBehavior(),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: OffersGroup.values.length,
                itemBuilder: (context, i) {
                  final group = OffersGroup.values[i];
                  return _DashboardOffersCard(
                      offersGroup: group,
                      onTap: () {
                        context.router.push(
                          OffersScreenRoute(
                            offersScreenNotifier: ref.watch(offersScreenRiverpodProvider(offersGroups: {group})),
                          ),
                        );
                      });
                },
                separatorBuilder: (context, index) => Spacing.$2x.widthBox,
              ),
            ),
          ),
        ],
      );
}

class _DashboardOffersCard extends StatelessWidget {
  static const height = 134.0;
  final OffersGroup offersGroup;
  final VoidCallback onTap;

  const _DashboardOffersCard({
    required this.offersGroup,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.xl)),
        child: SizedBox(
          width: 252,
          height: height,
          child: GestureDetector(
            onTap: onTap,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: offersGroup.color,
                  begin: context.isLTR ? Alignment.topLeft : Alignment.topRight,
                  end: context.isLTR ? Alignment.bottomRight : Alignment.bottomLeft,
                ),
              ),
              child: Stack(
                children: [
                  Positioned.directional(
                    textDirection: Directionality.of(context),
                    bottom: 0,
                    end: 0,
                    child: SizedBox(
                      height: 103,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: context.isLTR ? Matrix4.identity() : Matrix4.rotationY(pi),
                        child: Image.asset(
                          offersGroup.imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              offersGroup.title(context.l10n),
                              style: context.textStyleV3.h2SemiBold.copyWith(color: context.colorsV3.staticWhite),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.only(end: 2),
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
                            )
                          ],
                        ),
                        SizedBox(
                          width: 140,
                          child: Text(
                            offersGroup.description(context.l10n),
                            style:
                                context.textStyleV3.captionLargeRegular.copyWith(color: context.colorsV3.staticWhite),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
