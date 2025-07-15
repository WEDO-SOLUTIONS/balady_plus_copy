import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/tmp/content_row_expandable.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/ar_functions.dart';

class RoutingCollapsibleList extends StatelessWidget {
  final List<String> stations;
  final Color? lineColor;
  const RoutingCollapsibleList({
    required this.stations,
    this.lineColor,
    super.key,
  });

  static const contentRowStartPadding = Spacing.$4x;
  static const linePointCircleSize = 14.0;
  static const connectedLineWidth = 2.0;

  @override
  Widget build(BuildContext context) {
    if (stations.isEmpty) {
      return const SizedBox.shrink();
    }

    // Not possible to have only one station but we have to handle this case
    if (stations.length == 1) {
      return ContentWrapper.single(
        color: context.colorsV3.backgroundSurface1,
        child: ContentRowV2(
          leading: _StationItem(
            lineColor: lineColor ?? context.colorsV3.neutralDefault,
          ),
          text: ContentRowTextOptions(title: stations.first),
        ),
      );
    }

    return ContentWrapper.single(
      color: context.colorsV3.backgroundSurface1,
      child: Stack(
        children: [
          // This is line between first and last station. We have to position it correctly
          // to make it look like it is connected to the stations.
          PositionedDirectional(
            start: lineStartPosition,
            top: 16,
            bottom: 16,
            child: Container(
              width: connectedLineWidth,
              color: (lineColor ?? context.colorsV3.neutralDefault).withOpacity(0.5),
            ),
          ),
          Column(
            children: [
              ContentRowV2(
                leading: _StationItem(lineColor: lineColor ?? context.colorsV3.neutralDefault),
                text: ContentRowTextOptions(title: stations.first),
              ),
              if (stations.length > 2)
                ContentRowExpandableTmp(
                  onTitleTapExpand: true,
                  expandIconColor: context.colorsV3.foregroundMuted,
                  padding: EdgeInsets.zero,
                  leading: Container(
                    width: linePointCircleSize,
                    color: context.colorsV3.backgroundSurface1,
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: (lineColor ?? context.colorsV3.neutralDefault).withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  text: ContentRowTextOptions(
                    title: _getStationsCount(context),
                    titleOptions: ContentRowTextOption(
                      baseColor: context.colorsV3.foregroundSoft,
                    ),
                  ),
                  content: Padding(
                    padding: const EdgeInsetsDirectional.only(
                        start: contentRowStartPadding + linePointCircleSize + 12 + connectedLineWidth / 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _getStationsNames()
                              ?.map(
                                (e) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                                  child: Text(
                                    e,
                                    style: context.textStyleV3.bodySmallRegular.copyWith(
                                      color: context.colorsV3.foregroundSoft,
                                    ),
                                  ),
                                ),
                              )
                              .toList() ??
                          [],
                    ),
                  ),
                )
              else
                const SizedBox(height: Spacing.$4x),
              ContentRowV2(
                leading: _StationItem(
                  lineColor: lineColor ?? context.colorsV3.neutralDefault,
                ),
                text: ContentRowTextOptions(title: stations.last),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // All this positions are according to the `ContentRowV2` widget.
  // If we change paddings inside `ContentRowV2` we have to change this function also
  double get lineStartPosition => contentRowStartPadding + (linePointCircleSize / 2) - (connectedLineWidth / 2);

  // This is count of stations that are between first and last station.
  String _getStationsCount(BuildContext context) {
    if (stations.length <= 2) {
      return '-';
    }

    return ArPlurals.stations(stations.length - 2, context.l10n);
  }

  // This is names between first and last station. UI for fist (start) and last (finish)
  // is different than the middle ones
  // We will show them according to the design inside expanded list.
  List<String>? _getStationsNames() {
    if (stations.length <= 2) {
      return null;
    }

    return stations.sublist(1, stations.length - 1);
  }
}

class _StationItem extends StatelessWidget {
  final Color lineColor;
  const _StationItem({
    required this.lineColor,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: lineColor,
          shape: BoxShape.circle,
          boxShadow: Shadows.m,
        ),
      );
}
