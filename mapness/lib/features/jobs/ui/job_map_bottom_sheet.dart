import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart' hide SearchBar, ScrollPosition;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/weather/provider/weather_map_controls.dart';
import 'package:mapness/app/routes/jobs_map.dart';
import 'package:mapness/features/jobs/providers/job_list_provider.dart';
import 'package:mapness/features/jobs/ui/widgets/job_card.dart';
import 'package:mapness/features/jobs/ui/widgets/job_header.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';

const colorPrimary = Color(0xff1E2A36);

class JobMapBottomSheet extends ConsumerStatefulWidget {
  const JobMapBottomSheet({
    super.key,
    required this.biggestHeight,
    required this.biggestWidth,
  });

  final double biggestHeight;
  final double biggestWidth;

  @override
  ConsumerState<JobMapBottomSheet> createState() => _JobMapBottomSheetState();
}

class _JobMapBottomSheetState extends ConsumerState<JobMapBottomSheet> {
  late final DraggableScrollableController _draggableScrollableController;

  double get _headerExtent => 100 / widget.biggestHeight;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();

    _draggableScrollableController = DraggableScrollableController()
      ..addListener(() {
        Future.delayed(Duration.zero, () {
          var size = _draggableScrollableController.size;
          var sizeFixed = double.parse(size.toStringAsFixed(2));
          var headerExtentFixed =
              double.parse(_headerExtent.toStringAsFixed(2));
          final mapControls = ref.read(weatherMapControlsProvider.notifier);

          if (sizeFixed > headerExtentFixed) {
            mapControls.update(
              controlsVisible: false,
            );
          } else if (sizeFixed == headerExtentFixed) {
            var extent = widget.biggestHeight * sizeFixed;
            mapControls.update(
              extent: extent,
              controlsVisible: true,
            );
          } else if (sizeFixed < headerExtentFixed && sizeFixed != .1) {
            mapControls.update(controlsVisible: false);
          } else if (sizeFixed == .1) {
            var extent = widget.biggestHeight * sizeFixed;
            mapControls.update(
              controlsVisible: true,
              extent: extent,
            );
          }
        });
      });
  }

  @override
  void dispose() {
    _draggableScrollableController.dispose();
    super.dispose();
  }

  bool _needLoadMore() {
    final mEx = _scrollController?.position.maxScrollExtent;
    final cEx = _scrollController?.position.pixels;
    if (mEx == null || cEx == null) return false;
    final d = mEx - cEx;
    return d < 100;
  }

  @override
  Widget build(BuildContext context) {
    final jobsObjectManager = ref.watch(
      mapObjectManagerProvider(named: "jobs").notifier,
    );
    final jobsList = ref.watch(jobListResponseProvider(page: 1, size: 10));

    ref.listen(
      jobListResponseProvider(page: 1, size: 10),
      (previous, next) async {
        await jobsObjectManager.removeAllMarkers();

        final records = next.valueOrNull?.records;
        if (records == null) return;

        List<Marker> markers = [];
        for (final record in records) {
          if (record.location?.latitude == null ||
              record.location?.longitude == null) {
            continue;
          }

          markers.add(
            Marker(
              id: record.id!,
              onTap: () {
                JobsMapDetail(jobId: record.id!).push(context);
              },
              options: MarkerOptionsMessage(
                position: GeoPointWithElevationMessage(
                  latitude: double.parse(record.location!.latitude!),
                  longitude: double.parse(record.location!.longitude!),
                  elevation: 0,
                ),
                icon: MarkerIconMessage(
                  path: "packages/mapness/assets/icons/svg/job_pin.svg",
                  width: 24,
                ),
              ),
            ),
          );
        }

        await jobsObjectManager.addMarkers(markers);
        await ref
            .read(cameraPositionProvider.notifier)
            .animateToMarkers(markers);
      },
    );

    return DraggableScrollableSheet(
      controller: _draggableScrollableController,
      initialChildSize: _headerExtent,
      minChildSize: .1,
      maxChildSize: .9,
      snap: true,
      snapSizes: [.1, _headerExtent, .9],
      builder: (BuildContext context, ScrollController scrollController) {
        _scrollController = scrollController;
        scrollController.addListener(() {
          if (_needLoadMore()) {
            ref
                .read(jobListResponseProvider(page: 1, size: 10).notifier)
                .loadNextPage();
          }
        });

        return Directionality(
          textDirection: Directionality.of(context),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xffF4F4F5),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.0),
                topLeft: Radius.circular(16.0),
              ),
            ),
            child: jobsList.maybeWhen(
              orElse: () => const SizedBox.shrink(),
              data: (data) {
                return CustomScrollView(
                  controller: scrollController,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    SliverPersistentHeader(
                      delegate: JobHeaderDelegate(
                        draggableScrollableController:
                            _draggableScrollableController,
                      ),
                      pinned: false,
                    ),
                    SliverList.builder(
                      itemCount: data?.records?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) => JobCard(
                        jobModel: data!.records![index],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
