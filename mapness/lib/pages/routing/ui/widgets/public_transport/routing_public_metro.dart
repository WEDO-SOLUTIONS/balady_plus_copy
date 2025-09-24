part of 'routing_public_transport_content.dart';

class RoutingPublicMetro extends StatelessWidget {
  final List<String> stations;
  final Color? lineColor;
  final String? lineName;
  const RoutingPublicMetro({
    required this.stations,
    this.lineColor,
    this.lineName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (stations.length < 2) {
      logger.log('stations.length: ${stations.length}. Returning empty widget');
      return const SizedBox.shrink();
    }

    final lineColor = this.lineColor ?? context.colors.neutralDefault;

    return ContentWrapper.single(
      color: context.colors.backgroundSurface1,
      child: Stack(
        children: [
          // This is line between first and last station. We have to position it correctly
          // to make it look like it is connected to the stations.
          PositionedDirectional(
            start: lineStartPosition,
            top: 16,
            bottom: 16,
            child: Container(
              width: _connectedLineWidth,
              color: lineColor.withOpacity(0.5),
            ),
          ),
          Column(
            children: [
              // First station. Start
              RoutingPublicContentRow(
                title: stations.first,
                leadingIconColor: lineColor,
                lineColor: lineColor,
                lineName: lineName,
                padding: const EdgeInsetsDirectional.only(start: Spacing.$4x, end: Spacing.$4x),
              ),

              // Stations between first and last station.
              if (stations.length > 2)
                RoutingCollapsibleListStations(
                  stations: stations,
                  lineColor: lineColor,
                )
              else
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: _linePointCircleSize + _connectedLineWidth / 2 + _contentRowStartPadding + Spacing.$3x,
                    top: Spacing.$3x,
                    bottom: Spacing.$4x,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          context.l10n.nextStop,
                          style: context.textStyles.bodySmallRegular.copyWith(
                            color: context.colors.foregroundSoft,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Final station. Finish
              RoutingPublicContentRow(
                title: stations.last,
                leadingIconColor: lineColor,
                padding: const EdgeInsetsDirectional.only(start: Spacing.$4x, end: Spacing.$4x),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // All this positions are according to the `ContentRowV2` widget.
  // If we change paddings inside `ContentRowV2` we have to change this function also
  double get lineStartPosition => _contentRowStartPadding + (_linePointCircleSize / 2) - (_connectedLineWidth / 2);
}

class RoutingCollapsibleListStations extends StatelessWidget {
  final List<String> stations;
  final Color lineColor;
  final String? lineName;

  const RoutingCollapsibleListStations({
    required this.stations,
    required this.lineColor,
    this.lineName,
    super.key,
  });

  @override
  Widget build(BuildContext context) => RoutingPublicExpandable(
        padding: const EdgeInsetsDirectional.only(
          start: Spacing.$4x,
          end: Spacing.$4x,
          top: Spacing.$3x,
          bottom: Spacing.$3x,
        ),
        leading: (isExpanded) => isExpanded
            ? const SizedBox(width: _linePointCircleSize)
            : Container(
                width: _linePointCircleSize,
                color: context.colors.backgroundSurface1,
                padding: const EdgeInsets.all(3),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: lineColor.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
        firstText: _getStationsCount(context),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _getStationsNames()
                  ?.map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Row(
                        children: [
                          Container(
                            width: _linePointCircleSize,
                            color: context.colors.backgroundSurface1,
                            padding: const EdgeInsets.all(3),
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: lineColor.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const SizedBox(width: Spacing.$3x),
                          Text(
                            e,
                            style: context.textStyles.bodySmallRegular.copyWith(
                              color: context.colors.foregroundDefault,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList() ??
              [],
        ),
      );

  // This is names between first and last station. UI for fist (start) and last (finish)
  // is different than the middle ones
  // We will show them according to the design inside expanded list.
  List<String>? _getStationsNames() {
    if (stations.length <= 2) {
      return null;
    }

    return stations.sublist(1, stations.length - 1);
  }

  // This is count of stations that are between first and last station.
  String _getStationsCount(BuildContext context) {
    if (stations.length <= 2) {
      return '-';
    }

    return ArPlurals.stations(stations.length - 2, context.l10n);
  }
}
