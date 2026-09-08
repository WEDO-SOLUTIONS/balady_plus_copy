import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/poi_card/extensions/organizations_ext.dart';
import 'package:mapness/features/poi_card/provider/poi_card_provider.dart';
import 'package:mapness/features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';

class PoiTabs extends ConsumerStatefulWidget {
  final PoiCardState? poiCardState;
  final int objectId;
  final TabController tabController;

  const PoiTabs({required this.tabController, required this.objectId, super.key, this.poiCardState});

  @override
  ConsumerState<PoiTabs> createState() => _PoiTabsState();
}

class _PoiTabsState extends ConsumerState<PoiTabs> {
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      if (widget.tabController.indexIsChanging) {
        if (!mounted) {
          return;
        }

        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final photos = ref.watch(poiPhotoProvider(widget.objectId));

    final photoCount = photos.whenOrNull(data: (data) => data.items.length) ?? 0;
    final organizationsCount = widget.poiCardState?.organizations?.count ?? 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.$4x),
      child: TabBar(
        padding: EdgeInsets.zero,
        controller: widget.tabController,
        indicatorColor: Colors.transparent,
        isScrollable: true,
        labelPadding: EdgeInsets.zero,
        tabs: [
          Tab(
            iconMargin: EdgeInsets.zero,
            child: _PoiTabItem(
              title: context.l10n.info,
              onTap: () {
                Metrics.logEventAdvanced(
                  MetricsConstants.poiKeys.tab,
                  group: MetricsConstants.poiTag,
                  action: MetricAction.tap.toString(),
                  props: {'tab': context.l10n.info},
                );
                widget.tabController.animateTo(0);
              },
              isActive: widget.tabController.index == 0,
            ),
          ),
          Tab(
            iconMargin: EdgeInsets.zero,
            child: _PoiTabItem(
              title: context.l10n.photos,
              count: photoCount,
              onTap: () {
                Metrics.logEventAdvanced(
                  MetricsConstants.poiKeys.tab,
                  group: MetricsConstants.poiTag,
                  action: MetricAction.tap.toString(),
                  props: {'tab': context.l10n.photos},
                );

                widget.tabController.animateTo(1);
              },
              isActive: widget.tabController.index == 1,
            ),
          ),
          Tab(
            iconMargin: EdgeInsets.zero,
            child: organizationsCount > 0
                ? _PoiTabItem(
                    title: context.l10n.organizations,
                    count: organizationsCount,
                    onTap: () {
                      if (organizationsCount == 0) {
                        widget.tabController.index = widget.tabController.previousIndex;
                        return;
                      }
                      widget.tabController.animateTo(2);
                    },
                    isActive: widget.tabController.index == 2,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _PoiTabItem extends StatelessWidget {
  final bool? isActive;
  final VoidCallback? onTap;
  final String title;
  final int? count;

  const _PoiTabItem({required this.title, this.isActive, this.onTap, this.count});

  @override
  Widget build(BuildContext context) {
    final isActive = this.isActive ?? false;
    final hasCounter = count != null && count != 0;
    return Padding(
      padding: const EdgeInsets.all(Spacing.px),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isActive ? context.colors.foregroundSegmentedControl : Colors.transparent,
          borderRadius: BorderRadius.circular(RadiusBorder.m),
          boxShadow: isActive ? Shadows.s : null,
        ),
        child: SizedBox(
          // height: 36,
          child: Material(
            color: Colors.transparent,
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(RadiusBorder.m),
              onTap: onTap,
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: Spacing.$3x,
                  end: hasCounter ? Spacing.$2x : Spacing.$3x,
                  top: Spacing.$2x + Spacing.px,
                  bottom: Spacing.$2x + Spacing.px,
                ),
                child: Center(
                  child: Row(
                    children: [
                      Text(
                        title,
                        style: context.textStyles.bodySmallMedium.copyWith(
                          color: isActive ? context.colors.foregroundDefault : context.colors.foregroundSoft,
                        ),
                      ),
                      if (hasCounter)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: Spacing.$1x + Spacing.$0_5x),
                          child: FittedBox(
                            child: Counter(
                              count: count,
                              color: isActive ? context.colors.neutralDefault : context.colors.neutralContainerDefault,
                              counterColor: isActive ? null : context.colors.foregroundDisabled,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
