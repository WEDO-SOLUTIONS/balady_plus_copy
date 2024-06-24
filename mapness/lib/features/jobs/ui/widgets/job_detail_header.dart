import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/jobs/providers/job_detail_provider.dart';
import 'package:mapness/features/jobs/ui/widgets/ui/header_wrapper.dart';
import 'package:shimmer/shimmer.dart';

const double headerSize = 100;

class JobDetailHeaderDelegate extends SliverPersistentHeaderDelegate {
  JobDetailHeaderDelegate({
    required this.jobId,
    required this.draggableScrollableController,
  });
  final String jobId;

  final DraggableScrollableController draggableScrollableController;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) =>
      DashboardHeader(
        jobId: jobId,
        draggableScrollableController: draggableScrollableController,
      );

  @override
  double get maxExtent => headerSize;

  @override
  double get minExtent => headerSize;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({
    required this.jobId,
    required this.draggableScrollableController,
    super.key,
  });
  final String jobId;

  final DraggableScrollableController draggableScrollableController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final job = ref.watch(
      jobDetailProvider(
        id: jobId,
      ),
    );

    return job.maybeWhen(
      orElse: () => HeaderWrapper(
        child: Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
            ),
          ),
        ),
      ),
      data: (data) => Material(
        color: Colors.transparent,
        child: HeaderWrapper(
          child: Container(
            height: headerSize,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data?.name ?? '',
                        style: context.textStyle.heading2,
                      ),
                      Text(
                        data?.provider?.name ?? '',
                        maxLines: 2,
                        style: context.textStyle.footNote.apply(
                          color: context.color.textAndIconsBasePrimary.withOpacity(.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
