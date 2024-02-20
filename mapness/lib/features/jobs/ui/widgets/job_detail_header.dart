import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/jobs/providers/job_detail_provider.dart';
import 'package:mapness/features/jobs/ui/widgets/ui/header_wrapper.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:shimmer/shimmer.dart';

const double headerSize = 100;

class JobDetailHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String jobId;

  JobDetailHeaderDelegate({
    required this.jobId,
    required this.draggableScrollableController,
  });

  final DraggableScrollableController draggableScrollableController;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
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
  final String jobId;

  const DashboardHeader({
    required this.jobId,
    required this.draggableScrollableController,
    super.key,
  });

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
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .accentL,
                      ),
                      Text(
                        data?.provider?.name ?? '',
                        maxLines: 2,
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .textS
                            .apply(
                              color: context.color.text_and_icons_base_primary.withOpacity(.5),
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
