import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/entities/makkah_places/makkah_place_model.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/features/makkah_places/makkah_places_repository.dart';
import 'package:mapness/shared/config/environment_config.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/makkah_config_staging.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

class MakkahPlacesDebugPanel extends ConsumerWidget {
  const MakkahPlacesDebugPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placesAsync = ref.watch(makkahPlacesRepositoryProvider);

    // Only rebuild when location changes by ~100m (0.001° ≈ 111m)
    // to avoid excessive rebuilds from raw GPS updates.
    ref.watch(
      locationProvider.select((loc) {
        if (loc == null) return null;
        return (
          (loc.latitude * 1000).round(),
          (loc.longitude * 1000).round(),
        );
      }),
    );
    final location = ref.read(locationProvider);

    final envAsync = ref.watch(dgisEnvTypeProvider);

    return DebugCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DebugSectionHeader(
            icon: Icons.place_rounded,
            title: 'Makkah Places Debug',
            gradient: DebugTheme.gradientAmber,
          ),
          const SizedBox(height: 14),
          // Environment info
          envAsync.when(
            data: (env) => _EnvironmentInfo(env: env),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          if (location == null)
            const _InfoBox(
              icon: Icons.location_off_rounded,
              message: 'Location not available',
              color: DebugTheme.warning,
            )
          else
            _LocationInfo(location: location),
          const SizedBox(height: 12),
          placesAsync.when(
            data: (places) => _PlacesList(places: places, userLocation: location),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(color: DebugTheme.accent),
              ),
            ),
            error: (e, _) => _InfoBox(
              icon: Icons.error_outline_rounded,
              message: 'Error: $e',
              color: DebugTheme.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationInfo extends StatelessWidget {
  const _LocationInfo({required this.location});

  final Position location;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: DebugTheme.surfaceLight,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        const Icon(Icons.my_location_rounded, size: 14, color: DebugTheme.success),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '${location.latitude.toStringAsFixed(5)}, ${location.longitude.toStringAsFixed(5)}',
            style: context.textStyles.captionSmallMedium.copyWith(
              color: DebugTheme.textSecondary,
              fontFamily: 'monospace',
              fontSize: 11,
            ),
          ),
        ),
      ],
    ),
  );
}

class _PlacesList extends StatelessWidget {
  const _PlacesList({required this.places, required this.userLocation});

  final List<MakkahPlace> places;
  final Position? userLocation;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return const _InfoBox(
        icon: Icons.info_outline_rounded,
        message: 'No Makkah places loaded',
        color: DebugTheme.textMuted,
      );
    }

    // Sort places by distance if we have user location
    final sortedPlaces = List<MakkahPlace>.from(places);
    if (userLocation != null) {
      sortedPlaces.sort((a, b) {
        final distA = _calculateDistance(a, userLocation!);
        final distB = _calculateDistance(b, userLocation!);
        return distA.compareTo(distB);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${places.length} PLACES',
          style: context.textStyles.captionSmallMedium.copyWith(
            color: DebugTheme.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        ...sortedPlaces.map(
          (place) => _PlaceItem(
            place: place,
            userLocation: userLocation,
          ),
        ),
      ],
    );
  }

  double _calculateDistance(MakkahPlace place, Position location) {
    if (place.lat == null || place.lon == null) return double.infinity;
    return CommonFunctions.distance(
      location.latitude,
      location.longitude,
      place.lat!,
      place.lon!,
    );
  }
}

class _PlaceItem extends ConsumerWidget {
  const _PlaceItem({required this.place, required this.userLocation});

  final MakkahPlace place;
  final Position? userLocation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasCoords = place.lat != null && place.lon != null;
    final distance = hasCoords && userLocation != null
        ? CommonFunctions.distance(
            userLocation!.latitude,
            userLocation!.longitude,
            place.lat!,
            place.lon!,
          )
        : null;

    // Get route info
    final objectId = int.tryParse(place.dgisId ?? '') ?? 0;
    final finishPoint = hasCoords
        ? RouteSearchPoint(
            coordinates: GeoPointMessage(
              latitude: place.lat!,
              longitude: place.lon!,
            ),
            dgisObjectId: DgisObjectIdMessage(
              objectId: objectId,
              entranceId: 0,
            ),
          )
        : null;

    // Pass startPoint: null to let SDK use its internal location tracking
    // The provider watches locationProvider for realtime updates
    final pedestrianInfo = finishPoint != null
        ? ref.watch(
            briefRouteInfoProvider(
              finishPoint: finishPoint,
              navType: RouteSearchOptionsMessage.pedestrian,
            ),
          )
        : null;

    final carInfo = finishPoint != null
        ? ref.watch(
            briefRouteInfoProvider(
              finishPoint: finishPoint,
              navType: RouteSearchOptionsMessage.car,
            ),
          )
        : null;

    // Calculate estimated times from straight-line distance
    // (as a sanity check against SDK values)
    String? estimatedWalkTime;
    String? estimatedCarTime;
    if (distance != null) {
      // Average walking speed: 5 km/h, driving speed: 30 km/h
      final walkMinutes = (distance / 5.0 * 60).round();
      final carMinutes = (distance / 30.0 * 60).round();
      estimatedWalkTime = '~${walkMinutes > 0 ? walkMinutes : 1} min';
      estimatedCarTime = '~${carMinutes > 0 ? carMinutes : 1} min';
    }

    // Determine icon type (same logic as place_preview_makkah.dart)
    bool useWalkIcon = false;
    String? walkDuration;
    String? carDuration;
    int? walkDistanceMeters;
    int? carDistanceMeters;
    String? walkReason;
    bool sdkDataSuspicious = false;

    if (carInfo != null && carInfo.isNotEmpty) {
      final info = carInfo.first;
      carDistanceMeters = info.extraInfo.distance;
      final carDurationMinutes = (info.duration / 60).round();
      carDuration = '$carDurationMinutes min';
    }

    if (pedestrianInfo != null && pedestrianInfo.isNotEmpty) {
      final walkInfo = pedestrianInfo.first;
      walkDistanceMeters = walkInfo.extraInfo.distance;
      final walkDurationMinutes = (walkInfo.duration / 60).round();
      walkDuration = '$walkDurationMinutes min';
    }

    // Check if SDK data is suspicious (route distance >> straight-line distance)
    if (distance != null) {
      final straightLineMeters = (distance * 1000).round();
      if (walkDistanceMeters != null && walkDistanceMeters > straightLineMeters * 20) {
        sdkDataSuspicious = true;
      }
      if (carDistanceMeters != null && carDistanceMeters > straightLineMeters * 20) {
        sdkDataSuspicious = true;
      }
    }

    // Use straight-line based estimates if SDK data is suspicious
    if (sdkDataSuspicious && distance != null) {
      final distanceMeters = (distance * 1000).round();
      // Use simple logic: < 1km = walk
      useWalkIcon = distanceMeters < 1000;
      walkReason = sdkDataSuspicious ? 'SDK suspicious' : null;
    }
    // Priority 1: If car distance < 1km, always use walk icon
    else if (carDistanceMeters != null && carDistanceMeters < 1000) {
      useWalkIcon = true;
      walkReason = 'car < 1km';
    }
    // Priority 2: Check pedestrian info for 1-4km
    else if (walkDistanceMeters != null && walkDistanceMeters < 4000) {
      final walkDurationMinutes = (pedestrianInfo!.first.duration / 60).round();
      if (walkDurationMinutes < 40) {
        useWalkIcon = true;
        walkReason = 'walk < 4km & < 40min';
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: DebugTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DebugTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Place name
          Row(
            children: [
              Expanded(
                child: Text(
                  place.titleEn ?? place.placeId ?? 'Unknown',
                  style: context.textStyles.captionSmallSemiBold.copyWith(
                    color: DebugTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Icon type indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: useWalkIcon ? DebugTheme.success.withOpacity(0.15) : DebugTheme.info.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      useWalkIcon ? Icons.directions_walk : Icons.directions_car,
                      size: 12,
                      color: useWalkIcon ? DebugTheme.success : DebugTheme.info,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      useWalkIcon ? 'WALK' : 'CAR',
                      style: context.textStyles.captionSmallMedium.copyWith(
                        color: useWalkIcon ? DebugTheme.success : DebugTheme.info,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (walkReason != null) ...[
                      const SizedBox(width: 4),
                      Text(
                        '($walkReason)',
                        style: context.textStyles.captionSmallRegular.copyWith(
                          color: DebugTheme.textMuted,
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // SDK data warning
          if (sdkDataSuspicious)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: DebugTheme.error.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 12, color: DebugTheme.error),
                  const SizedBox(width: 4),
                  Text(
                    'SDK data suspicious!',
                    style: context.textStyles.captionSmallMedium.copyWith(
                      color: DebugTheme.error,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          // Distance and duration info
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              if (distance != null)
                _MetricChip(
                  icon: Icons.straighten_rounded,
                  label: _formatDistance(distance),
                  color: DebugTheme.textSecondary,
                ),
              // Estimated times (from straight-line distance)
              if (estimatedWalkTime != null)
                _MetricChip(
                  icon: Icons.directions_walk,
                  label: estimatedWalkTime,
                  sublabel: '(est)',
                  color: DebugTheme.accent,
                ),
              if (estimatedCarTime != null)
                _MetricChip(
                  icon: Icons.directions_car,
                  label: estimatedCarTime,
                  sublabel: '(est)',
                  color: DebugTheme.accent,
                ),
            ],
          ),
          // SDK values (for comparison)
          if (walkDuration != null || carDuration != null) ...[
            const SizedBox(height: 4),
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                Text(
                  'SDK:',
                  style: context.textStyles.captionSmallRegular.copyWith(
                    color: sdkDataSuspicious ? DebugTheme.error : DebugTheme.textMuted,
                    fontSize: 9,
                  ),
                ),
                if (walkDuration != null)
                  _MetricChip(
                    icon: Icons.directions_walk,
                    label: walkDuration,
                    sublabel: walkDistanceMeters != null ? '(${_formatDistanceMeters(walkDistanceMeters)})' : null,
                    color: sdkDataSuspicious ? DebugTheme.error : DebugTheme.success,
                  ),
                if (carDuration != null)
                  _MetricChip(
                    icon: Icons.directions_car,
                    label: carDuration,
                    sublabel: carDistanceMeters != null ? '(${_formatDistanceMeters(carDistanceMeters)})' : null,
                    color: sdkDataSuspicious ? DebugTheme.error : DebugTheme.info,
                  ),
              ],
            ),
          ],
          if (pedestrianInfo == null && carInfo == null)
            const _MetricChip(
              icon: Icons.hourglass_empty_rounded,
              label: 'Loading...',
              color: DebugTheme.textMuted,
            ),
          // Coordinates debug info
          if (hasCoords) ...[
            const SizedBox(height: 6),
            Text(
              'To: ${place.lat!.toStringAsFixed(5)}, ${place.lon!.toStringAsFixed(5)}',
              style: context.textStyles.captionSmallRegular.copyWith(
                color: DebugTheme.textMuted,
                fontFamily: 'monospace',
                fontSize: 9,
              ),
            ),
          ],
          if (userLocation != null) ...[
            const SizedBox(height: 2),
            Text(
              'From: ${userLocation!.latitude.toStringAsFixed(5)}, ${userLocation!.longitude.toStringAsFixed(5)}',
              style: context.textStyles.captionSmallRegular.copyWith(
                color: DebugTheme.accent,
                fontFamily: 'monospace',
                fontSize: 9,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDistance(double distanceKm) {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).round()} m';
    }
    return '${distanceKm.toStringAsFixed(1)} km';
  }

  String _formatDistanceMeters(int meters) {
    if (meters < 1000) {
      return '$meters m';
    }
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.icon,
    required this.label,
    required this.color,
    this.sublabel,
  });

  final IconData icon;
  final String label;
  final String? sublabel;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 12, color: color),
      const SizedBox(width: 4),
      Text(
        label,
        style: context.textStyles.captionSmallMedium.copyWith(
          color: color,
          fontSize: 10,
        ),
      ),
      if (sublabel != null) ...[
        const SizedBox(width: 2),
        Text(
          sublabel!,
          style: context.textStyles.captionSmallRegular.copyWith(
            color: DebugTheme.textMuted,
            fontSize: 9,
          ),
        ),
      ],
    ],
  );
}

class _EnvironmentInfo extends StatelessWidget {
  const _EnvironmentInfo({required this.env});

  final DgisEnv env;

  @override
  Widget build(BuildContext context) {
    final isStaging = MakkahConfigUrls.isStagingEnv(env);
    final placesUrl = MakkahConfigUrls.getPlacesUrl(env);
    final configUrl = MakkahConfigUrls.getConfigUrl(env);

    final textColor = isStaging ? Colors.white : DebugTheme.textPrimary;
    final mutedColor = isStaging ? Colors.white.withOpacity(0.7) : DebugTheme.textMuted;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: isStaging ? DebugTheme.gradientAmber : null,
        color: isStaging ? null : DebugTheme.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isStaging ? Colors.transparent : DebugTheme.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isStaging ? Icons.science_rounded : Icons.public_rounded,
                size: 16,
                color: isStaging ? Colors.white : DebugTheme.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Backend Config (${env.name})',
                  style: context.textStyles.captionSmallMedium.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isStaging ? Colors.white.withOpacity(0.2) : DebugTheme.warning.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isStaging ? 'STG' : 'PROD',
                  style: context.textStyles.captionSmallMedium.copyWith(
                    color: isStaging ? Colors.white : DebugTheme.warning,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _UrlRow(label: 'places.json', url: placesUrl, textColor: mutedColor),
          const SizedBox(height: 4),
          _UrlRow(label: 'config.json', url: configUrl, textColor: mutedColor),
        ],
      ),
    );
  }
}

class _UrlRow extends StatelessWidget {
  const _UrlRow({
    required this.label,
    required this.url,
    required this.textColor,
  });

  final String label;
  final String url;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    // Extract the path part after /o/ for display
    final pathStart = url.indexOf('/o/');
    final displayPath = pathStart != -1 ? url.substring(pathStart + 3) : url;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: context.textStyles.captionSmallMedium.copyWith(
              color: textColor,
              fontSize: 9,
            ),
          ),
        ),
        Expanded(
          child: Text(
            displayPath,
            style: context.textStyles.captionSmallRegular.copyWith(
              color: textColor,
              fontFamily: 'monospace',
              fontSize: 9,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({
    required this.icon,
    required this.message,
    required this.color,
  });

  final IconData icon;
  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: context.textStyles.captionSmallRegular.copyWith(
              color: color,
            ),
          ),
        ),
      ],
    ),
  );
}
