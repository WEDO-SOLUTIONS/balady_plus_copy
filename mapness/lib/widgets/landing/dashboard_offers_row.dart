import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/_features/common/scroll/no_glowing_scroll_behavior.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/saudi_pass/offers_group.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class DashboardOffersRow extends ConsumerStatefulWidget {
  const DashboardOffersRow({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardOffersRow> createState() => _DashboardOffersRowState();
}

class _DashboardOffersRowState extends ConsumerState<DashboardOffersRow> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  int _itemCount = 0;

  @override
  void initState() {
    super.initState();
    _itemCount = OffersGroupExtension.mainCategories.length;
    _scrollController.addListener(_updatePage);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updatePage);
    _scrollController.dispose();
    super.dispose();
  }

  void _updatePage() {
    if (!_scrollController.hasClients) return;
    const double itemWidth = 252 + 8; // width + spacing
    final double scrollPosition = _scrollController.position.pixels;
    final int page = (scrollPosition / itemWidth).round();
    if (_currentPage != page && page >= 0 && page < _itemCount) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            context.router.push(OffersScreenViewRoute());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
            child: SvgPicture.asset(
              'packages/mapness/assets/icons/svg/tadalal_logo_${context.isLTR ? "en" : "ar"}.svg',
              height: 24,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: _DashboardOffersCard.height,
          child: ScrollConfiguration(
            behavior: NoGlowingScrollBehavior(),
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _itemCount,
              itemBuilder: (_, i) {
                final group = OffersGroupExtension.mainCategories[i];
                return _DashboardOffersCard(
                  offersGroup: group,
                  onTap: () {
                    context.router.push(OffersScreenViewRoute(offersGroup: group));
                  },
                );
              },
              separatorBuilder: (context, index) => Spacing.$2x.widthBox,
            ),
          ),
        ),
        const SizedBox(height: Spacing.$3x),
        // Dots indicator
        if (_itemCount > 1)
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                _itemCount,
                    (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: Spacing.$1x),
                  width: _currentPage == index ? 7.5 : 7.5,
                  height: 7.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentPage == index
                        ? context.colors.staticBlack
                        : context.colors.borderMuted,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
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
              Positioned(
                top: offersGroup.imagePosition.$1,
                bottom: offersGroup.imagePosition.$2,
                left: context.isLTR
                    ? offersGroup.imagePosition.$3
                    : offersGroup.imagePosition.$4,
                right: context.isLTR
                    ? offersGroup.imagePosition.$4
                    : offersGroup.imagePosition.$3,
                child: SizedBox(
                  height: 103,
                  width: 120,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: (offersGroup.needsFlipInRtl && !context.isLTR)
                        ? Matrix4.rotationY(pi)
                        : Matrix4.identity(),
                    child: Image.asset(
                      offersGroup.imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          offersGroup.title(context.l10n),
                          style: context.textStyleV3.h3SemiBold.copyWith(color: Color(0xFF1E2A36)),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 2),
                          child: SizedBox(
                            width: Spacing.$6x,
                            height: Spacing.$6x,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Spacing.$1_5x),
                                  color: Color(0xFF1B8354)
                              //  color: context.colorsV3.staticWhite.withOpacity(0.2),
                              ),
                              child: Center(
                                child: Icon(
                                  SystemIcons.arrowCornerRightSmall,
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
                        context.textStyleV3.captionLargeRegular.copyWith(color: Color(0xFF1E2A36)),
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