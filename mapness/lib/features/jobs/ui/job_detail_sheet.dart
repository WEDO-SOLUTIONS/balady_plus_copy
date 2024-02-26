import 'package:flutter/material.dart' hide ScrollPosition, SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/jobs/ui/widgets/job_detail.dart';
import 'package:mapness/features/jobs/ui/widgets/job_detail_header.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class JobDetailSheet extends ConsumerStatefulWidget {

  const JobDetailSheet({
    required this.jobId,
    required this.biggestHeight,
    required this.biggestWidth,
    super.key,
  });
  final String jobId;

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

    _draggableScrollableController = DraggableScrollableController();
  }

  @override
  void dispose() {
    _draggableScrollableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
        controller: _draggableScrollableController,
        initialChildSize: .9,
        minChildSize: .1,
        maxChildSize: .9,
        snap: true,
        snapSizes: [.1, _headerExtent, .9],
        builder: (context, scrollController) => Directionality(
          textDirection: Directionality.of(context),
          child: Container(
            decoration:  BoxDecoration(
              color: context.color.surface_base_primary,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
            ),
            child: CustomScrollView(
              controller: scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  delegate: JobDetailHeaderDelegate(
                    jobId: widget.jobId,
                    draggableScrollableController:
                        _draggableScrollableController,
                  ),
                ),
                SliverToBoxAdapter(
                  child: JobDetail(jobId: widget.jobId),
                ),
              ],
            ),
          ),
        ),
      );
}
