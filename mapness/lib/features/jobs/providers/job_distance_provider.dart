import 'package:dgis_map/library.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/features/jobs/data/models/job_distance_info.dart';
import 'package:mapness/shared/lib/geo/geo_utils.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'job_distance_provider.g.dart';

@riverpod
class JobDistance extends _$JobDistance {
  static const _metricEventName = 'Jobs: Calculate distance to job';
  @override
  Future<JobDistanceInfo?> build(double lat, double lon) async {
    final dgisController = await ref.watch(dgisControllerProvider.future);
    mixpanel?.timeEvent(_metricEventName);
    try {
      final data = await dgisController.search(
        '$lat, $lon',
        sortingType: SortingTypeMessage.byDistance,
      );
      if (data.firstPage?.items.isNotEmpty == true) {
        final responseDistance = GeoUtils.mapToRoutPoint(
          data.firstPage!.items,
        );

        if (responseDistance.isEmpty) {
          return null;
        }

        final briefPoint = responseDistance.first;

        final result = await dgisController.findBriefRouteInfos(
          options: RouteSearchOptionsMessage.car,
          finishPoint: briefPoint,
        );

        return JobDistanceInfo(
          briefMessages: result.whereType<BriefRouteInfoMessage>().toList(),
          point: briefPoint.coordinates,
          id: briefPoint.objectId,
        );
      }
    } on Exception catch (e) {
      logger.log('Error calculating distance to job: ${e.toString()}', logLevel: MapnessLogLevel.critical);
    } finally {
      await mixpanel?.track(_metricEventName);
    }
    return null;
  }
}
