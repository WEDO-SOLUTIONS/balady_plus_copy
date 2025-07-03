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
          PositionedDirectional(
            start: 16 + (14 / 2) - (2 / 2),
            top: 16,
            bottom: 16,
            child: Container(
              width: 2,
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
                  padding: EdgeInsets.zero,
                  leading: Container(
                    width: 14,
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
                    padding: const EdgeInsetsDirectional.only(start: 16 + 14 + 12 + 1),
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
                ),
              if (stations.length <= 2) const SizedBox(height: Spacing.$4x),
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

  String _getStationsCount(BuildContext context) {
    if (stations.length <= 2) {
      return '-';
    }

    return ArPlurals.stations(stations.length - 2, context.l10n);
  }

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
