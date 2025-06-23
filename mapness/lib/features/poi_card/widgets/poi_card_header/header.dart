import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:balady_uikit/core/widgets/dragger_contrainer.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';
import 'package:mapness/features/poi_card/extensions/poi_content/poi_content_ext.dart';
import 'package:mapness/features/poi_card/extensions/week_day_ext.dart';
import 'package:mapness/features/poi_card/provider/poi_card_provider.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/subtitle.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/tab.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/title.dart';
import 'package:mapness/shared/ui/sheets/card_header.dart';
import 'package:mapness/shared/ui/statefull_bottom_sheet/header_info_wrapper.dart';
import 'package:mapness/widgets/search/ui/search_item.dart';

class PoiHeader extends ConsumerWidget {
  static const poiHeaderHeight = 210.0;
  static const poiHeaderBorderRadius = RadiusBorder.xl;

  final String title;
  final String subTitle;
  final List<InlineSpan> subTitleExtraInlineSpans;
  final PoiCardState? poiCardState;
  final TabController? tabController;
  final ParkingInfoMessage? parkingInfo;
  final DirectoryObjectMessage? data;

  final Function()? onTapClose;

  const PoiHeader({
    required this.title,
    required this.subTitle,
    required this.onTapClose,
    this.tabController,
    this.parkingInfo,
    this.data,
    this.subTitleExtraInlineSpans = const [],
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

    // Header info
    final workingHours = data?.getOpeningHoursHeader(context);
    final showInfo = !(workingHours == null) &&
        (workingHours.workTimeType == WorkTimeType.closed || workingHours.workTimeType == WorkTimeType.almostClosed);
    final backgroundColor = workingHours?.workTimeType.backgroundColor(context);
    final textColor = workingHours?.workTimeType.foregroundColor(context);

    return HeaderInfoWrapper(
      text: workingHours?.poiContentWorkTime.workHours ?? '',
      backgroundColor: backgroundColor,
      textColor: textColor,
      isVisible: showInfo,
      child: ColoredBox(
        color: context.colors.backgroundSurface2,
        child: Padding(
          padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DraggerContainer(color: context.colors.backgroundSurface2),
              CardHeader(
                title: CardHeaderWidget(child: TitleComponent(title: title)),
                onTapClose: onTapClose,
                subTitle: CardHeaderWidget(
                  child: SubtitleComponent(
                    subtitle: _subTitle,
                    routeInfo: _data?.routeInfos.firstOrNull,
                    inlineSpans: subTitleExtraInlineSpans,
                    title: _data?.title,
                  ),
                ),
              ),
              if (_parkingObjectId) Spacing.$4x.heightBox,
              if (_tabController != null && !_parkingObjectId)
                TabComponent(
                  tabController: _tabController,
                  objectId: _data?.id?.objectId ?? 0,
                  poiCardState: poiCardState,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
