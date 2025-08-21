part of 'routing_public_transport_content.dart';

enum PedestrianSectorType {
  first,
  last,
}

class RoutingPublicTailSector extends ConsumerWidget {
  final List<RouteDetailsPublicTransport>? data;
  final PedestrianSectorType type;
  final RouteParamsPointWithLabel? pointLabel;

  const RoutingPublicTailSector({
    required this.data,
    required this.type,
    this.pointLabel,
    super.key,
  });

// It means that the first sector have to be shown as "My location" + line with pedestrian icon
  bool get _isFirstPedestrian => (data?.isNotEmpty ?? false) && (data!.first is RouteDetailsPublicTransportPedestrian);
  bool get _isLastPedestrian => (data?.isNotEmpty ?? false) && (data!.last is RouteDetailsPublicTransportPedestrian);

  double get lineStartPosition =>
      _contentRowStartPadding + (_linePointCircleSize / 2) - (_connectedLineWidth / 2) + 0.5;
  bool get showLine => switch (type) {
        PedestrianSectorType.first => true,
        PedestrianSectorType.last => (data ?? []).length > 1,
      };
  double get topPadding => switch (type) {
        PedestrianSectorType.first => 16 + 14,
        PedestrianSectorType.last => 0,
      };

  double get bottomPadding => switch (type) {
        PedestrianSectorType.first => 0,
        PedestrianSectorType.last => 16 + 14 + 20,
      };

  VerticalDirection get verticalDirection => switch (type) {
        PedestrianSectorType.first => VerticalDirection.down,
        PedestrianSectorType.last => VerticalDirection.up,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!_isFirstPedestrian && type == PedestrianSectorType.first) {
      return const SizedBox(height: Spacing.$3x);
    }

    if (!_isLastPedestrian && type == PedestrianSectorType.last) {
      return const SizedBox(height: Spacing.$3x);
    }

    final bulletColor = switch (type) {
      PedestrianSectorType.first => context.colors.accentDefault,
      PedestrianSectorType.last => context.colors.extra01Default,
    };

    final defaultPointLabel = switch (type) {
      PedestrianSectorType.first => context.l10n.myLocation,
      PedestrianSectorType.last => context.l10n.destination,
    };

    final topPaddingValue = switch (type) {
      PedestrianSectorType.first => Spacing.$4x,
      PedestrianSectorType.last => Spacing.$3x + Spacing.$4x,
    };

    final bottomPaddingValue = switch (type) {
      PedestrianSectorType.first => Spacing.$3x + Spacing.$4x,
      PedestrianSectorType.last => Spacing.$4x,
    };

    final address = addressById(pointLabel?.value?.objectId, ref);

    return Stack(
      children: [
        if (showLine)
          PositionedDirectional(
            start: lineStartPosition,
            top: topPadding,
            bottom: bottomPadding,
            child: CustomPaint(
              painter: DashedLinePainter(),
              size: const Size(
                _connectedLineWidth,
                100,
              ),
            ),
          ),
        Column(
          verticalDirection: verticalDirection,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: Spacing.$4x,
                end: Spacing.$4x,
                top: showLine ? Spacing.$4x : 0.0,
                bottom: Spacing.$4x,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    GeneralIcons.bulletCircleSolid,
                    color: bulletColor,
                    size: _linePointCircleSize,
                  ),
                  Spacing.$3x.widthBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pointLabel?.label ?? defaultPointLabel,
                        style: context.textStyles.bodyLargeRegular.copyWith(
                          color: context.colors.foregroundDefault,
                        ),
                      ),
                      Spacing.$1x.heightBox,
                      FutureBuilder(
                        future: address,
                        builder: (context, snapshot) => Text(
                          snapshot.data ?? context.l10n.loading,
                          style: context.textStyles.bodySmallRegular.copyWith(
                            color: context.colors.foregroundSoft,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (showLine)
              RoutingPublicPedestrian(
                data: data!.first as RouteDetailsPublicTransportPedestrian,
                topPadding: topPaddingValue,
                bottomPadding: bottomPaddingValue,
              ),
          ],
        ),
      ],
    );
  }

  Future<String?> addressById(int? objectId, WidgetRef ref) async {
    if (objectId == null) {
      return null;
    }
    final dgisController = await ref.read(dgisControllerProvider.future);
    final object = await dgisController.searchByObjectId(DgisObjectIdMessage(objectId: objectId, entranceId: 0));

    return object.makeFullAddress();
  }
}
