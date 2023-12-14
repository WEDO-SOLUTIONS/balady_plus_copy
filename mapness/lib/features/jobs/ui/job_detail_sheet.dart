import 'package:flutter/material.dart' hide SearchBar, ScrollPosition;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/weather/provider/weather_map_controls.dart';
import 'package:mapness/features/jobs/providers/job_list_provider.dart';
import 'package:mapness/features/jobs/ui/widgets/job_detail.dart';
import 'package:mapness/features/jobs/ui/widgets/job_detail_header.dart';

const colorPrimary = Color(0xff1E2A36);

class JobDetailSheet extends ConsumerStatefulWidget {
  final String jobId;

  const JobDetailSheet({
    super.key,
    required this.jobId,
    required this.biggestHeight,
    required this.biggestWidth,
  });

  final double biggestHeight;
  final double biggestWidth;

  @override
  ConsumerState<JobDetailSheet> createState() => _JobDetailSheetState();
}

class _JobDetailSheetState extends ConsumerState<JobDetailSheet> {
  late final DraggableScrollableController _draggableScrollableController;

  double get _headerExtent => 120 / widget.biggestHeight;

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

  @override
  Widget build(BuildContext context) {
    final jobsList = ref.watch(jobListResponseProvider(page: 1, size: 10));

    return DraggableScrollableSheet(
      controller: _draggableScrollableController,
      initialChildSize: 1,
      minChildSize: .1,
      maxChildSize: 1,
      snap: true,
      snapSizes: [.1, _headerExtent, 1],
      builder: (BuildContext context, ScrollController scrollController) {
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
                      delegate: JobDetailHeaderDelegate(
                        jobId: widget.jobId,
                        draggableScrollableController:
                            _draggableScrollableController,
                      ),
                      pinned: false,
                    ),
                    SliverToBoxAdapter(
                      child: JobDetail(jobId: widget.jobId),
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
