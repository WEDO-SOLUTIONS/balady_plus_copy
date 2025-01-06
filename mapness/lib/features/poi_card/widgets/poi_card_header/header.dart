import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/features/poi_card/provider/poi_card_provider.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/header_info_component.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/subtitle.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/tab.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/title.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/sheets/card_header.dart';
import 'package:mapness/widgets/search/ui/search_item.dart';

const poiHeaderHeight = 210.0;

class PoiHeader extends ConsumerWidget {
  final PoiCardState? poiCardState;
  final TabController tabController;
  final DirectoryObjectMessage data;
  final Function()? onTapClose;

  const PoiHeader({
    required this.data,
    required this.onTapClose,
    required this.tabController,
    super.key,
    this.poiCardState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final direction = ref.watch(uiDirectionProvider);

    final address = data.address;

    String subTitle = _getParkingSubtitle(data, context.l10n) ?? data.subtitle;

    // TODO(Ayat) API, returns English text for Arabic. Is temporary solution
    if (prefixMapping.containsKey(subTitle.toLowerCase())) {
      subTitle = switch (direction) {
        TextDirection.ltr => subTitle,
        TextDirection.rtl => prefixMapping[subTitle.toLowerCase()]!,
      };
    }

    final subtitleIcon = _getParkingIcon(data);
    final title = address?.buildingName ?? data.title;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: context.colorsV2.backgroundScreen,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(RadiusBorder.xl),
            topRight: Radius.circular(RadiusBorder.xl),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardHeader(
              title: CardHeaderWidget(child: TitleComponent(title: title)),
              onTapClose: onTapClose,
              subTitle: CardHeaderWidget(
                child: SubtitleComponent(
                  subtitle: subTitle,
                  subtitleIcon: subtitleIcon,
                ),
              ),
            ),
            HeaderInfoComponent(
              data: data,
            ),
            TabComponent(
              tabController: tabController,
              objectId: data.id?.objectId ?? 0,
              poiCardState: poiCardState,
            ),
          ],
        ),
      ),
    );
  }

  /// This is temporary solution. We need to show text for parking info
  /// If parking is not presented for this POI we return null
  /// Should work for all poi because only parking lots have parking info
  String? _getParkingSubtitle(
      DirectoryObjectMessage data, AppLocalizations l10n) {
    final parkingInfo = data.parkingInfo;
    if (parkingInfo == null) {
      return null;
    }
    final total = parkingInfo.capacity?.total;
    final freeText = parkingInfo.isPaid ? l10n.paid : l10n.free;
    if (total == null) {
      return freeText;
    }
    return '$total ${l10n.lots} • $freeText';
  }

  IconData? _getParkingIcon(DirectoryObjectMessage data) {
    final parkingInfo = data.parkingInfo;
    if (parkingInfo == null) {
      return null;
    }
    return parkingInfo.isPaid
        ? GeneralIcons.money
        : GeneralIcons.checkmarkCircle;
  }
}
