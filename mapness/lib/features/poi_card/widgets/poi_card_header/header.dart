import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:balady_uikit/core/widgets/dragger_contrainer.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/features/jeddah_bus/repo.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/enums/poi_tabs_type.dart';
import 'package:mapness/features/poi_card/provider/poi_card_provider.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/rating.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/subtitle.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/tab.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/title.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/sheets/card_header.dart';
import 'package:mapness/shared/ui/statefull_bottom_sheet/header_info_wrapper.dart';
import 'package:mapness/widgets/search/ui/search_item.dart';
import 'package:mapness/widgets/search/ui/working_hours.dart';
import 'package:mapness/widgets/search/ui/working_hours_colors.dart';
import 'package:mapness/widgets/search/ui/working_hours_from_opening_hours_message.dart';
import 'package:mapness/widgets/search/ui/working_hours_strings.dart';
import 'package:mapness/widgets/search/ui/working_hours_threshold_provider.dart';
import 'package:sheetify/sheetify.dart' hide DraggerContainer;

class PoiHeader extends ConsumerWidget {
  static const poiHeaderHeight = 210.0;
  static const poiHeaderBorderRadius = RadiusBorder.xl;

  final Color? color;
  final String title;
  final String subTitle;
  final List<InlineSpan> subTitleExtraInlineSpans;
  final PoiCardState? poiCardState;
  final TabController? tabController;

  /// Tabs driven by [tabController], in its index order.
  final List<PoiTabsType> tabs;
  final ParkingInfoMessage? parkingInfo;
  final DirectoryObjectMessage? data;
  final MultiStateSheetController<PoiCardBottomSheetState>? bottomSheetController;
  final ToggleSheetController? toggleSheetController;

  final Function()? onTapClose;

  const PoiHeader({
    required this.title,
    required this.subTitle,
    required this.onTapClose,
    this.color,
    this.tabController,
    this.tabs = PoiTabsType.cardTabsDefault,
    this.parkingInfo,
    this.data,
    this.subTitleExtraInlineSpans = const [],
    this.bottomSheetController,
    this.toggleSheetController,
    super.key,
    this.poiCardState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final direction = ref.watch(uiDirectionProvider);
    late final String _subTitle;

    // TODO(Ayat) API, returns English text for Arabic. Is temporary solution
    if (prefixMapping.containsKey(subTitle.toLowerCase())) {
      _subTitle = switch (direction) {
        TextDirection.ltr => subTitle,
        TextDirection.rtl => prefixMapping[subTitle.toLowerCase()]!,
      };
    } else {
      _subTitle = subTitle;
    }

    final _tabController = tabController;
    final _data = data;

    final _parkingObjectId = _data?.id?.objectId == parkingObjectId;
    final showRating = _tabController != null && !_parkingObjectId && tabs.contains(PoiTabsType.reviews);

    // Header info
    final workingHours = data?.openingHours?.toWorkingHours();
    final soonThreshold = ref
        .watch(workingHoursSoonThresholdProvider)
        .maybeWhen(
          data: (value) => value,
          orElse: () => kDefaultWorkingHoursSoonThreshold,
        );
    final now = saudiTimeNow();
    final closedStatus = workingHours?.closedStatus(now, context.l10n, soonThreshold: soonThreshold) ?? '';
    final closedStatusColors = workingHours?.colors(now, context.colors, soonThreshold: soonThreshold);

    final isStationDirectoryObject =
        ref.watch(jeddahBusLayerRepoProvider).value?.isStationDirectoryObject(data) ?? false;

    return HeaderInfoWrapper(
      text: closedStatus,
      backgroundColor: closedStatusColors?.background,
      textColor: closedStatusColors?.text,
      isVisible: closedStatus.isNotEmpty,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          final multiStateController = bottomSheetController;
          if (multiStateController != null) {
            final currentState = multiStateController.state;
            switch (currentState) {
              case PoiCardBottomSheetState.hidden:
                multiStateController.setState(PoiCardBottomSheetState.halfOpen);
                break;
              case PoiCardBottomSheetState.halfOpen:
                multiStateController.setState(PoiCardBottomSheetState.open);
                break;
              case PoiCardBottomSheetState.open:
                multiStateController.setState(PoiCardBottomSheetState.halfOpen);
                break;
              case PoiCardBottomSheetState.expanded:
                multiStateController.setState(PoiCardBottomSheetState.open);
                break;
            }
            return;
          }

          final toggleController = toggleSheetController;
          if (toggleController != null) {
            if (toggleController.isClosed) {
              toggleController.open();
            } else {
              toggleController.close();
            }
          }
        },
        child: AnimatedBuilder(
          animation: bottomSheetController ?? const _DummyAnimation(),
          builder: (context, _) {
            final state = bottomSheetController?.state;
            final shouldUseSurface1 =
                state != null && (state == PoiCardBottomSheetState.open || state == PoiCardBottomSheetState.expanded);
            final backgroundColor = shouldUseSurface1
                ? context.colors.backgroundSurface1
                : context.colors.backgroundSurface2;
            return ColoredBox(
              color: backgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DraggerContainer(color: backgroundColor),
                    CardHeader(
                      title: CardHeaderWidget(child: TitleComponent(title: title)),
                      onTapClose: onTapClose,
                      subTitle: CardHeaderWidget(
                        child: SubtitleComponent(
                          subtitle: _subTitle,
                          // do not show route info for manually managed stations
                          routeInfo: isStationDirectoryObject ? null : _data?.routeInfos,
                          inlineSpans: subTitleExtraInlineSpans,
                          title: _data?.title,
                        ),
                      ),
                    ),
                    if (_parkingObjectId) Spacing.$4x.heightBox,
                    if (showRating) RatingComponent(objectId: _data?.id?.objectId ?? 0),
                    if (_tabController != null && !_parkingObjectId) ...[
                      const SizedBox(height: Spacing.$1x),
                      TabComponent(
                        tabController: _tabController,
                        objectId: _data?.id?.objectId ?? 0,
                        poiCardState: poiCardState,
                        tabs: tabs,
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DummyAnimation extends Animation<double> {
  const _DummyAnimation();

  @override
  void addListener(VoidCallback listener) {}

  @override
  void addStatusListener(AnimationStatusListener listener) {}

  @override
  void removeListener(VoidCallback listener) {}

  @override
  void removeStatusListener(AnimationStatusListener listener) {}

  @override
  AnimationStatus get status => AnimationStatus.completed;

  @override
  double get value => 1.0;
}
