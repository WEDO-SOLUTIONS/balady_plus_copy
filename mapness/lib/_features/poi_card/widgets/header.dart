import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/_features/poi_card/enums/poi_tabs_type.dart';
import 'package:mapness/_features/poi_card/provider/poi_card_provider.dart';
import 'package:mapness/_features/poi_card/widgets/poi_tabs.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';
import 'package:mapness/widgets/search/ui/search_item.dart';

class PoiHeader extends ConsumerWidget {
  final PoiCardState? poiCardState;
  final TabController tabController;
  final DirectoryObjectMessage data;
  final ValueListenable<Expansion> expansionState;
  final ValueNotifier<PoiTabsType> tabState;
  final Function()? onTapClose;

  const PoiHeader({
    required this.data,
    required this.onTapClose,
    required this.tabController,
    required this.expansionState,
    required this.tabState,
    super.key,
    this.poiCardState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final direction = ref.watch(uiDirectionProvider);

    final address = data.address;
    String subTitle = _getParkingSubtitle(data, context.l10n) ?? data.subtitle;

    // TODO(Ayat) API, returns English text for Arabic. Is temporary solution
    if (prefixMapping.containsKey(subTitle)) {
      subTitle = switch (direction) {
        TextDirection.ltr => subTitle,
        TextDirection.rtl => prefixMapping[subTitle]!,
      };
    }

    final subtitleIcon = _getParkingIcon(data);
    final title = address?.buildingName ?? data.title;

    final titleTextStyle = context.textStyle.heading1.copyWith(
      color: context.color.textAndIconsBasePrimary,
    );
    final subTitleTextStyle = context.textStyle.footNote.copyWith(
      color: context.color.textAndIconsBaseSecondary,
    );

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Spacing.$2x),
          const Center(child: SheetDragger()),
          const SizedBox(height: Spacing.$3x),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: expansionState,
                      builder: (_, expansion, __) => Text(
                        title,
                        style: titleTextStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: expansion != Expansion.hidden ? 2 : 1,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: tabState,
                      builder: (_, tabState, __) => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: tabState == PoiTabsType.info
                            ? ValueListenableBuilder(
                                valueListenable: expansionState,
                                builder: (_, expansion, child) => AnimatedSize(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  child: expansion != Expansion.hidden ? child : const SizedBox.shrink(),
                                ),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        subTitle,
                                        style: subTitleTextStyle,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    if (subtitleIcon != null) ...[
                                      const SizedBox(width: Spacing.$1x),
                                      Icon(
                                        subtitleIcon,
                                        color: context.color.textAndIconsBaseSecondary,
                                        size: 24,
                                      )
                                    ]
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.$3x),
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
                        child: SvgPicture.asset(
                          'assets/icons/svg/ic_search_close.svg',
                          semanticsLabel: 'MinApps Screen',
                          package: PackageConfig.packageName,
                          colorFilter: ColorFilter.mode(
                            context.color.textAndIconsBasePrimary.withOpacity(0.7),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          ValueListenableBuilder(
              valueListenable: expansionState,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: Spacing.$2x,
                  bottom: Spacing.$3x,
                ),
                child: PoiTabs(
                  tabController: tabController,
                  objectId: data.id?.objectId ?? 0,
                  poiCardState: poiCardState,
                ),
              ),
              builder: (_, expansion, child) => AnimatedSize(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    child: expansion != Expansion.hidden ? child : const SizedBox(),
                  )),
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
