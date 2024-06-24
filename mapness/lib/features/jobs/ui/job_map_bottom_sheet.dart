import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart' hide ScrollPosition, SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/jobs_map.dart';
import 'package:mapness/features/jobs/data/models/job_list_model.dart';
import 'package:mapness/features/jobs/data/models/job_model.dart';
import 'package:mapness/features/jobs/providers/job_list_provider.dart';
import 'package:mapness/features/jobs/ui/widgets/job_card.dart';
import 'package:mapness/features/jobs/ui/widgets/job_header.dart';
import 'package:mapness/shared/extensions/scroll_controller_ext.dart';
import 'package:mapness/shared/lib/geo/geo_utils.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/routing/current_route_provider.dart';

class JobMapBottomSheet extends ConsumerStatefulWidget {
  const JobMapBottomSheet({
    required this.biggestHeight,
    required this.biggestWidth,
    super.key,
  });

  final double biggestHeight;
  final double biggestWidth;

  @override
  ConsumerState<JobMapBottomSheet> createState() => _JobMapBottomSheetState();
}

class _JobMapBottomSheetState extends ConsumerState<JobMapBottomSheet> {
  late final DraggableScrollableController _draggableScrollableController;

  ScrollController? _scrollController;

  void _handleScroll() {
    if (_scrollController?.isCloseToEnd == true) {
      ref.read(jobListProvider().notifier).loadNextPage();
    }
  }

  @override
  void initState() {
    super.initState();

    _draggableScrollableController = DraggableScrollableController();
  }

  @override
  void dispose() {
    _draggableScrollableController.dispose();
    _scrollController?.removeListener(_handleScroll);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobsList = ref.watch(jobListProvider());
    final settings = MapObjectManagerSettings.jobs();
    final jobsObjectManager = ref.watch(
      mapObjectManagerProvider(
        named: settings.name,
        layerId: settings.layerId,
      ).notifier,
    );
    ref.listen(
      jobListProvider(),
      (_, next) => _addMarkers(
        jobsModel: next.unwrapPrevious().valueOrNull,
        jobsObjectManager: jobsObjectManager,
      ),
    );

    return DraggableScrollableSheet(
      controller: _draggableScrollableController,
      minChildSize: .1,
      maxChildSize: .9,
      snap: true,
      snapSizes: const [.1, .5, .9],
      builder: (context, scrollController) {
        // scrooll controller disposed in DraggableScrollableSheet
        _scrollController = scrollController;

        scrollController
          ..removeListener(_handleScroll)
          ..addListener(_handleScroll);

        return Directionality(
          textDirection: Directionality.of(context),
          child: Container(
            decoration: BoxDecoration(
              color: context.color.surfaceBasePrimary,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
            ),
            child: jobsList.maybeWhen(
              orElse: () => const SizedBox.shrink(),
              data: (data) => CustomScrollView(
                controller: scrollController,
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverPersistentHeader(
                    delegate: JobHeaderDelegate(
                      draggableScrollableController: _draggableScrollableController,
                    ),
                  ),
                  SliverList.builder(
                    itemCount: data?.records?.length ?? 0,
                    itemBuilder: (context, index) => JobCard(
                      jobModel: data!.records![index],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _addMarkers({
    required JobListModel? jobsModel,
    required MapObjectManager jobsObjectManager,
  }) async {
    await jobsObjectManager.removeAllMarkers();

    final records = jobsModel?.records;
    if (records == null) {
      return;
    }

    final markers = <Marker>[];
    for (final record in records) {
      final lon = double.tryParse(record.location?.longitude ?? '');
      final lat = double.tryParse(record.location?.latitude ?? '');

      if (lon == null || lat == null || record.id == null) {
        continue;
      }

      markers.add(
        Marker(
          id: record.id!,
          onTap: () => _openMarker(record),
          options: MarkerOptionsMessage(
            position: GeoPointWithElevationMessage(
              longitude: lon,
              latitude: lat,
              elevation: 1,
            ),
            icon: MarkerIconMessage(
              path: 'packages/mapness/assets/icons/svg/job_pin.svg',
              width: 24,
            ),
          ),
        ),
      );
    }

    await jobsObjectManager.addMarkers(markers);

    // Move camera to markers or zoom by markers nearby
    final cameraPosition = ref.read(cameraPositionProvider);
    if (cameraPosition == null) {
      await ref.read(cameraPositionProvider.notifier).animateToMarkers(markers);
    } else {
      final zoom = await GeoUtils.zoomByMarkersNearby(
        markers: markers,
        position: cameraPosition.point,
      );
      await ref.read(cameraPositionProvider.notifier).animateTo(
            CameraPositionMessage(
              zoom: zoom,
              bearing: 0,
              point: cameraPosition.point,
              tilt: 0,
            ),
          );
    }
  }

  void _openMarker(JobModel model) {
    final lon = double.tryParse(model.location?.longitude ?? '');
    final lat = double.tryParse(model.location!.latitude ?? '');

    if (lon == null || lat == null) {
      return;
    }

    ref.read(cameraPositionProvider.notifier).animateTo(
          CameraPositionMessage(
            zoom: 15,
            bearing: 0,
            point: GeoPointMessage(
              longitude: lon,
              latitude: lat,
            ),
            tilt: 0,
          ),
        );

    final jobId = model.id;

    if (jobId == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    final currentRoute = ref.read(currentRouteProvider);
    if (currentRoute?.currentPath != null && RegExp('/job/.*/detail').hasMatch(currentRoute!.currentPath!)) {
      JobsMapDetail(jobId: jobId).pushReplacement(context);
      return;
    }
    JobsMapDetail(jobId: jobId).push(context);
  }
}
