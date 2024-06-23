import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/jobs/providers/jobs_statistic_provider.dart';
import 'package:mapness/features/jobs/ui/widgets/ui/header_wrapper.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:shimmer/shimmer.dart';

const double headerSize = 100;

class JobHeaderDelegate extends SliverPersistentHeaderDelegate {
  JobHeaderDelegate({
    required this.draggableScrollableController,
  });

  final DraggableScrollableController draggableScrollableController;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) =>
      JobHeader(
        draggableScrollableController: draggableScrollableController,
      );

  @override
  double get maxExtent => headerSize;

  @override
  double get minExtent => headerSize;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class JobHeader extends ConsumerWidget {
  const JobHeader({
    required this.draggableScrollableController,
    super.key,
  });

  final DraggableScrollableController draggableScrollableController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsStatistic = ref.watch(jobStatisticProvider);

    return jobsStatistic.maybeWhen(
      orElse: () => HeaderWrapper(
        child: SizedBox(
          width: double.infinity,
          height: headerSize,
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
      ),
      skipError: true,
      data: (data) => Material(
        color: Colors.transparent,
        child: HeaderWrapper(
          child: Container(
            width: double.infinity,
            height: headerSize,
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
                Text(
                  context.l10n.jobs,
                  style: context.textStyle.heading2,
                ),
                Text(
                  '${data?.jobsCount ?? 0} ${context.l10n.vacancies}',
                  style: context.textStyle.footNote.apply(color: context.color.textAndIconsBasePrimary.withOpacity(.5)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
