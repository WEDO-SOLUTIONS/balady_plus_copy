import 'dart:async';
import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/makkah_places/makkah_place_model.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/features/makkah_places/makkah_multilingual_helper.dart';
import 'package:mapness/features/makkah_places/makkah_places_repository.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/brief_route_info_message_ext.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';
import 'package:mapness/features/special_themes/modes/mekkah_base/makkah_poi_constants.dart';
import 'package:mapness/shared/lib/common_functions.dart';

/// Width of place preview card in Makkah dashboard
const kPlaceCardSizeMakkah = MakkahPoiConstants.placeCardWidth;

/// Rounded location to prevent excessive rebuilds from GPS jitter.
/// Precision: ~100m (0.001 degrees ≈ 111m)
@immutable
class _RoundedLocation {
  final double latitude;
  final double longitude;

  const _RoundedLocation({
    required this.latitude,
    required this.longitude,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _RoundedLocation &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}

class PlacePreviewMakkah extends ConsumerStatefulWidget {
  const PlacePreviewMakkah({
    super.key,
    this.excludeDgisId,
    this.excludePlaceId,
  });

  final String? excludeDgisId;
  final String? excludePlaceId;

  @override
  ConsumerState<PlacePreviewMakkah> createState() => _PlacePreviewMakkahState();
}

class _PlacePreviewMakkahState extends ConsumerState<PlacePreviewMakkah> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ref
        .watch(makkahPlacesRepositoryProvider)
        .when(
          data: (items) {
            // Optimize: Only trigger rebuild when location changes significantly
            // (more than ~100m), not on every GPS update
            final userLocation = ref.watch(
              locationProvider.select(
                (location) => location == null
                    ? null
                    : _RoundedLocation(
                        // Round to ~100m precision (0.001 degrees ≈ 111m)
                        latitude: (location.latitude * 1000).round() / 1000,
                        longitude: (location.longitude * 1000).round() / 1000,
                      ),
              ),
            );
            var places = items
                .where((e) => (e.previewImageUrl ?? '').isNotEmpty)
                .where(
                  (e) => (widget.excludePlaceId ?? '').isEmpty || e.placeId != widget.excludePlaceId,
                )
                .where(
                  (e) => (widget.excludeDgisId ?? '').isEmpty || e.dgisId != widget.excludeDgisId,
                )
                .toList();

            final fixed = places.where((e) => e.fixedOrderPosition != null).toList();
            final dynamic = places.where((e) => e.fixedOrderPosition == null).toList();

            fixed.sort(
              (a, b) => (a.fixedOrderPosition ?? 0).compareTo(b.fixedOrderPosition ?? 0),
            );

            // Sort only dynamic places by distance from user location
            if (userLocation != null) {
              dynamic.sort((a, b) {
                final distA = _calculateDistance(
                  userLocation.latitude,
                  userLocation.longitude,
                  a.lat ?? 0,
                  a.lon ?? 0,
                );
                final distB = _calculateDistance(
                  userLocation.latitude,
                  userLocation.longitude,
                  b.lat ?? 0,
                  b.lon ?? 0,
                );
                return distA.compareTo(distB);
              });
            }

            places = [...fixed, ...dynamic];

            return SliderListView<MakkahPlace?>(
              items: places,
              horizontalPadding: Spacing.$3x,
              separationWidth: Spacing.$2x,
              viewportWidth: MediaQuery.sizeOf(context).width,
              contentSize: kPlaceCardSizeMakkah,
              activeDotColor: SaudiNationalDay.isNow() ? context.colors.staticWhite : null,
              onTap: (item) async {
                if (item == null) return;

                final dgisId = int.tryParse(item.dgisId ?? '') ?? 0;

                Metrics.logEventAdvanced(
                  MetricsConstants.exploreKeys.placesToVisitBanner,
                  action: MetricAction.tap.name,
                  group: MetricsConstants.exploreTag,
                  props: {'id': dgisId, 'title': item.titleEn ?? ''},
                );

                // Track Makkah places specific metric
                Metrics.logEventAdvanced(
                  MetricsConstants.makkahPlacesKeys.placeCardTapped,
                  action: MetricAction.tap.name,
                  group: MetricsConstants.makkahPlacesTag,
                  props: {
                    'placeId': item.placeId ?? '',
                    'dgisId': dgisId,
                    'title': item.titleEn ?? '',
                  },
                );

                // Fly to marker location
                if (item.lat != null && item.lon != null) {
                  unawaited(
                    ref
                        .read(cameraPositionProvider.notifier)
                        .animateTo(
                          CameraPositionMessage(
                            point: GeoPointMessage(
                              latitude: item.lat!,
                              longitude: item.lon!,
                            ),
                            zoom: 20,
                            tilt: 0,
                            bearing: 0,
                          ),
                        ),
                  );
                }

                await context.router.replaceOrPush(
                  route: PoiMakkahWidgetRoute(
                    objectId: dgisId != 0
                        ? DgisObjectIdMessage(
                            objectId: dgisId,
                            entranceId: 0,
                          )
                        : null,
                    cameraConfig: const PoiCameraConfig(zoom: 20),
                    makkahPlace: item,
                  ),
                  toCompareRoutes: [PoiMakkahWidgetRoute.page],
                );
              },
              itemBuilder: (item) => _PlaceCardMakkah(item, key: ValueKey(item?.dgisId)),
            );
          },
          error: (error, trace) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: Spacing.$4x),
            child: _PlaceCardMakkah(null),
          ),
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(horizontal: Spacing.$4x),
            child: _PlaceCardMakkah(null),
          ),
        );
  }

  @override
  bool get wantKeepAlive => true;

  /// Haversine formula to calculate distance between two points
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371.0; // km
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) * math.cos(_toRadians(lat2)) * math.sin(dLon / 2) * math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * math.pi / 180;
}

class _PlaceCardMakkah extends ConsumerWidget {
  final MakkahPlace? item;

  const _PlaceCardMakkah(this.item, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finishPoint = (item?.lat != null && item?.lon != null)
        ? RouteSearchPoint(
            coordinates: GeoPointMessage(
              latitude: item!.lat!,
              longitude: item!.lon!,
            ),
            dgisObjectId: DgisObjectIdMessage(
              objectId: int.tryParse(item!.dgisId ?? '') ?? 0,
              entranceId: 0,
            ),
          )
        : null;

    final isDark = ref.watch(darkModeProvider).value?.isDark ?? false;
    final overlayPeak = isDark
        ? MakkahPoiConstants.darkPreviewCardOverlayColor
        : MakkahPoiConstants.previewCardOverlayColor;
    return ClipRRect(
      borderRadius: BorderRadius.circular(RadiusBorder.xl),
      child: Stack(
        children: [
          CachedNetworkImage(
            height: kPlaceCardSizeMakkah,
            width: double.infinity,
            imageUrl: item?.previewImageUrl ?? '',
            fit: BoxFit.cover,
            imageBuilder: (context, imageProvider) => Stack(
              children: [
                ShaderMask(
                  blendMode: BlendMode.srcATop,
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      overlayPeak.withOpacity(0),
                      overlayPeak,
                    ],
                    stops: const [0.0, 0.96],
                  ).createShader(bounds),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.expand(),
                    child: Image(image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                if (finishPoint != null)
                  Align(
                    alignment: context.isLTR ? Alignment.topLeft : Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(Spacing.$4x),
                      child: _TravelTimeChip(
                        finishPoint: finishPoint,
                        makkahPlace: item,
                      ),
                    ),
                  ),
                Align(
                  alignment: context.isLTR ? Alignment.bottomLeft : Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.$6x),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 260),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item != null)
                            Text(
                              MakkahMultilingualHelper.getTitle(
                                item!,
                                Directionality.of(context),
                              ),
                              style: context.textStyles.h2Medium.copyWith(
                                color: context.colors.staticWhite,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            progressIndicatorBuilder: (context, url, progress) => _ImagePlaceholderMakkah(progress: progress.progress),
            errorWidget: (context, error, _) => const _ImagePlaceholderMakkah(),
          ),
        ],
      ),
    );
  }
}

class _TravelTimeChip extends ConsumerWidget {
  final RouteSearchPoint finishPoint;
  final MakkahPlace? makkahPlace;

  const _TravelTimeChip({
    required this.finishPoint,
    this.makkahPlace,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get user location snapshot for straight-line distance calculation.
    // Using ref.read since route info is already periodically refreshed.
    final userLocation = ref.read(locationProvider);

    // Get both pedestrian and car route info
    // Pass startPoint: null to let SDK use its internal location tracking
    // The provider watches locationProvider for realtime updates
    final pedestrianInfo = ref.watch(
      briefRouteInfoProvider(
        startPoint: null,
        finishPoint: finishPoint,
        navType: RouteSearchOptionsMessage.pedestrian,
      ),
    );

    final carInfo = ref.watch(
      briefRouteInfoProvider(
        startPoint: null,
        finishPoint: finishPoint,
        navType: RouteSearchOptionsMessage.car,
      ),
    );

    // Calculate straight-line distance in meters for sanity checking
    double? straightLineMeters;
    if (userLocation != null) {
      final distanceKm = CommonFunctions.distance(
        userLocation.latitude,
        userLocation.longitude,
        finishPoint.coordinates.latitude,
        finishPoint.coordinates.longitude,
      );
      straightLineMeters = distanceKm * 1000;
    }

    // Determine which icon and duration to show
    String? durationText;
    bool useWalkIcon = false;

    // Get SDK distances
    final carDistance = (carInfo != null && carInfo.isNotEmpty) ? carInfo.first.extraInfo.distance : null;
    final walkDistance = (pedestrianInfo != null && pedestrianInfo.isNotEmpty)
        ? pedestrianInfo.first.extraInfo.distance
        : null;

    // Check if SDK data is suspicious (route distance >> straight-line distance)
    bool sdkDataSuspicious = false;
    if (straightLineMeters != null && straightLineMeters > 0) {
      if (carDistance != null && carDistance > straightLineMeters * 20) {
        sdkDataSuspicious = true;
      }
      if (walkDistance != null && walkDistance > straightLineMeters * 20) {
        sdkDataSuspicious = true;
      }
    }

    // If SDK data is suspicious, use estimated time from straight-line distance
    if (sdkDataSuspicious && straightLineMeters != null) {
      // Use walk for < 1km, car otherwise
      if (straightLineMeters < 1000) {
        useWalkIcon = true;
        final walkMinutes = (straightLineMeters / 1000 / 5.0 * 60).round();
        durationText = '${walkMinutes > 0 ? walkMinutes : 1} ${context.l10n.min}';
      } else {
        final carMinutes = (straightLineMeters / 1000 / 30.0 * 60).round();
        durationText = '${carMinutes > 0 ? carMinutes : 1} ${context.l10n.min}';
      }
    }
    // Priority 1: If car distance < 1km, always use walk icon (user is very close)
    // This handles cases where pedestrian routing returns unrealistic data
    else if (carDistance != null && carDistance < 1000) {
      useWalkIcon = true;
      // Use pedestrian duration if available and reasonable, otherwise car duration
      if (pedestrianInfo != null && pedestrianInfo.isNotEmpty) {
        final walkInfo = pedestrianInfo.first;
        final sdkWalkDistance = walkInfo.extraInfo.distance;
        // Only use pedestrian info if the distance is reasonable (not > 10x car distance)
        if (sdkWalkDistance < carDistance * 10) {
          durationText = walkInfo.getBriefRouteDescription(context.l10n);
        } else {
          durationText = carInfo!.first.getBriefRouteDescription(context.l10n);
        }
      } else {
        durationText = carInfo!.first.getBriefRouteDescription(context.l10n);
      }
    }
    // Priority 2: Check pedestrian info for distances 1-4km
    else if (pedestrianInfo != null && pedestrianInfo.isNotEmpty) {
      final walkInfo = pedestrianInfo.first;
      final sdkWalkDistance = walkInfo.extraInfo.distance; // in meters
      final walkDurationMinutes = (walkInfo.duration / 60).round();

      // Show walk icon if distance < 4km AND walk time < 40 min
      if (sdkWalkDistance < 4000 && walkDurationMinutes < 40) {
        useWalkIcon = true;
        durationText = walkInfo.getBriefRouteDescription(context.l10n);
      }
    }

    // If not using walk icon, use car info
    if (!useWalkIcon && durationText == null && carInfo != null && carInfo.isNotEmpty) {
      durationText = carInfo.first.getBriefRouteDescription(context.l10n);
    }

    // Get general tag
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final generalTag = makkahPlace != null ? (isArabic ? makkahPlace!.generalTagAr : makkahPlace!.generalTagEn) : null;
    final hasGeneralTag = generalTag != null && generalTag.isNotEmpty;
    final hasDuration = durationText != null && durationText.isNotEmpty;

    // Don't show anything if both are empty
    if (!hasGeneralTag && !hasDuration) {
      return const SizedBox.shrink();
    }

    final isDark = ref.watch(darkModeProvider).value?.isDark ?? false;
    final chipBg = isDark ? MakkahPoiConstants.darkMutedSlate : context.colors.staticWhite.withOpacity(0.9);
    final chipFg = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF4A3016);
    // Show two separate chips
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // First chip: travel time with icon
        if (hasDuration)
          DecoratedBox(
            decoration: BoxDecoration(
              color: chipBg,
              borderRadius: BorderRadius.circular(RadiusBorder.full),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.$3x,
                vertical: Spacing.$1x,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Mirror walk icon for RTL (Arabic)
                  Transform.scale(
                    scaleX: (useWalkIcon && Directionality.of(context) == TextDirection.rtl) ? -1 : 1,
                    child: Icon(
                      useWalkIcon ? Icons.directions_walk : Icons.directions_car,
                      size: 14,
                      color: chipFg,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    durationText!,
                    style: context.textStyles.bodySmallRegular.copyWith(
                      color: chipFg,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        // Spacing between chips
        if (hasDuration && hasGeneralTag) const SizedBox(width: Spacing.$2x),
        // Second chip: general tag
        if (hasGeneralTag)
          DecoratedBox(
            decoration: BoxDecoration(
              color: chipBg,
              borderRadius: BorderRadius.circular(RadiusBorder.full),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.$3x,
                vertical: Spacing.$1x,
              ),
              child: Text(
                generalTag!,
                style: context.textStyles.bodySmallRegular.copyWith(
                  color: chipFg,
                  fontSize: 11,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ImagePlaceholderMakkah extends StatelessWidget {
  final double? progress;

  const _ImagePlaceholderMakkah({this.progress});

  @override
  Widget build(BuildContext context) => const ShimmerEffectWidget();
}
