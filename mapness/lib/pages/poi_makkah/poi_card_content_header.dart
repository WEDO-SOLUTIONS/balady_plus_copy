part of 'poi_makkah_widget_page.dart';

class _MakkahPoiHeader extends StatelessWidget {
  final String title;
  final Widget subTitleWidget;
  final VoidCallback? onTapClose;
  final _MakkahPoiColors colors;

  const _MakkahPoiHeader({
    required this.title,
    required this.subTitleWidget,
    required this.onTapClose,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: colors.headerBackground,
    child: Padding(
      padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SheetDragger(),
          Padding(
            padding: const EdgeInsets.only(bottom: Spacing.$2x),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: context.textStyles.h3SemiBold.copyWith(
                          color: colors.titleColor,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: Spacing.$2x),
                      subTitleWidget,
                    ],
                  ),
                ),
                const SizedBox(width: Spacing.$3x),
                AppButton(
                  buttonColorScheme: ButtonColorScheme.neutral,
                  buttonType: ButtonType.secondary,
                  onTap: onTapClose,
                  primaryIcon: Icons.close,
                  color: colors.closeButtonBackground,
                  iconColor: colors.closeButtonIcon,
                  padding: EdgeInsets.zero,
                  innerPadding: const EdgeInsets.symmetric(
                    horizontal: Spacing.$2x,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _MakkahPoiSubtitle extends ConsumerWidget {
  final DirectoryObjectMessage data;
  final MakkahPlace? makkahPlace;
  final _MakkahPoiColors colors;

  const _MakkahPoiSubtitle({
    required this.data,
    required this.colors,
    this.makkahPlace,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final markerPosition = data.markerPosition;
    if (markerPosition == null) {
      return _buildStaticSubtitle(context, null, null, makkahPlace);
    }

    // Use coordinates hash as objectId when real id is not available
    // This ensures unique cache keys for briefRouteInfoProvider
    final coordsHash = markerPosition.latitude.hashCode ^ markerPosition.longitude.hashCode;
    final objectId = data.id?.objectId ?? coordsHash;

    final finishPoint = RouteSearchPoint(
      coordinates: markerPosition.toGeoPointMessage(),
      dgisObjectId: DgisObjectIdMessage(objectId: objectId, entranceId: 0),
    );

    // Get both pedestrian and car route info
    final pedestrianRouteInfo = ref.watch(
      briefRouteInfoProvider(
        finishPoint: finishPoint,
        navType: RouteSearchOptionsMessage.pedestrian,
      ),
    );

    final carRouteInfo = ref.watch(
      briefRouteInfoProvider(
        finishPoint: finishPoint,
        navType: RouteSearchOptionsMessage.car,
      ),
    );

    // Determine which icon and duration to show
    String? durationText;
    bool useWalkIcon = false;

    if (pedestrianRouteInfo != null && pedestrianRouteInfo.isNotEmpty) {
      final walkInfo = pedestrianRouteInfo.first;
      final walkDistance = walkInfo.extraInfo.distance; // in meters
      final walkDurationMinutes = (walkInfo.duration / 60).round();

      // Show walk icon if distance < 4km AND walk time < 40 min
      if (walkDistance < 4000 && walkDurationMinutes < 40) {
        useWalkIcon = true;
        durationText = walkInfo.getBriefRouteDescription(context.l10n);
      }
    }

    // If not using walk icon, use car info
    if (!useWalkIcon && carRouteInfo != null && carRouteInfo.isNotEmpty) {
      durationText = carRouteInfo.first.getBriefRouteDescription(context.l10n);
    }

    return _buildStaticSubtitle(context, durationText, useWalkIcon, makkahPlace);
  }

  Widget _buildStaticSubtitle(
    BuildContext context,
    String? durationText,
    bool? useWalkIcon,
    MakkahPlace? makkahPlace,
  ) {
    final textStyle = context.textStyles.bodySmallRegular.copyWith(
      color: colors.secondaryTextColor,
    );
    final iconColor = colors.secondaryTextColor;

    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final generalTag = isArabic ? makkahPlace?.generalTagAr : makkahPlace?.generalTagEn;

    final hasGeneralTag = generalTag != null && generalTag.isNotEmpty;
    final hasDuration = durationText != null && durationText.isNotEmpty;

    if (!hasGeneralTag && !hasDuration) {
      return const SizedBox.shrink();
    }

    // Choose icon based on useWalkIcon flag
    final iconPath = (useWalkIcon ?? false) ? MakkahPoiConstants.walkIconPath : MakkahPoiConstants.carIconPath;

    return Row(
      children: [
        // Show general tag first
        if (hasGeneralTag) Text(generalTag, style: textStyle),
        // Then separator and travel time
        if (hasGeneralTag && hasDuration) Text(' · ', style: textStyle),
        if (hasDuration) ...[
          SvgPicture.asset(
            iconPath,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            matchTextDirection: true,
          ),
          const SizedBox(width: 4),
          Text(durationText, style: textStyle),
        ],
      ],
    );
  }
}
