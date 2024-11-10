import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/poi_card/extensions/directory_object_ext.dart';
import 'package:mapness/_features/poi_card/provider/poi_card_provider.dart';
import 'package:mapness/_features/poi_card/widgets/poi_card_header/subtitle.dart';
import 'package:mapness/_features/poi_card/widgets/poi_card_header/tab.dart';
import 'package:mapness/_features/poi_card/widgets/poi_card_header/title.dart';
import 'package:mapness/_features/poi_card/widgets/poi_card_header/worktime.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/search/ui/search_item.dart';

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

    final workingHours = data.getOpeningHours(context.l10n);

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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x),
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(RadiusBorder.xl),
            topRight: Radius.circular(RadiusBorder.xl),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleComponent(title: title),
                    SubtitleComponent(
                      subtitle: subTitle,
                      subtitleIcon: subtitleIcon,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: Spacing.$3x,
              ),
              Builder(
                builder: (context) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Material(
                    borderRadius: borderRadius,
                    child: InkWell(
                      borderRadius: borderRadius,
                      onTap: onTapClose,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: context.color.textAndIconsBasePrimary.withAlpha(10),
                        ),
                        padding: const EdgeInsets.all(Spacing.$2x),
                        child: SystemIcons.close.icon(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (workingHours?.title != null)
            WorktimeComponent(
              worktime: workingHours!.title,
            ),
          TabComponent(
            tabController: tabController,
            objectId: data.id?.objectId ?? 0,
            poiCardState: poiCardState,
          ),
        ],
      ),
    );
  }

  /// This is temporary solution. We need to show text for parking info
  /// If parking is not presented for this POI we return null
  /// Should work for all poi because only parking lots have parking info
  String? _getParkingSubtitle(DirectoryObjectMessage data, AppLocalizations l10n) {
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
    return parkingInfo.isPaid ? GeneralIcons.money : GeneralIcons.checkmarkCircle;
  }
}
