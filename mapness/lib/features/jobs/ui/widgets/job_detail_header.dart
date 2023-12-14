import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/features/jobs/providers/job_detail_provider.dart';
import 'package:shimmer/shimmer.dart';

const double headerSize = 100;
const colorPrimary = Color(0xff1E2A36);
final borderRadius = BorderRadius.circular(16);

class JobDetailHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String jobId;

  JobDetailHeaderDelegate({
    required this.jobId,
    required this.draggableScrollableController,
  });

  final DraggableScrollableController draggableScrollableController;

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return DashboardHeader(
      jobId: jobId,
      draggableScrollableController: draggableScrollableController,
    );
  }

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
    super.key,
    required this.jobId,
    required this.draggableScrollableController,
  });

  final DraggableScrollableController draggableScrollableController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final job = ref.watch(jobDetailResponseProvider(
      id: jobId,
    ));

    return job.maybeWhen(orElse: () {
      return Shimmer.fromColors(
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
      );
    }, data: (data) {
      return Material(
        color: Colors.transparent,
        child: Container(
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
              children: [
                const SizedBox(
                  height: 8,
                ),
                _scrollHandle(),
                const SizedBox(
                  height: 6,
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data?.name ?? '',
                            style: Theme.of(context)
                                .extension<ThemeTextStyles>()!
                                .accentL,
                          ),
                          Text(
                            data?.description ?? '',
                            maxLines: 2,
                            style: Theme.of(context)
                                .extension<ThemeTextStyles>()!
                                .textS
                                .apply(
                                    color: const Color(0xff1E2A36)
                                        .withOpacity(.5)),
                          ),
                        ],
                      ),
                      _closeButton(onTap: () => context.pop()),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            )),
      );
    });
  }

  Widget _closeButton({Function()? onTap}) {
    return Material(
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Container(
          height: 40,
          width: 40,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            // color: Colors.white,
            color: Color(0xffF4F4F5),
          ),
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            "assets/icons/svg/ic_search_close.svg",
            semanticsLabel: 'MinApps Screen',
            package: "mapness",
            color: colorPrimary.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  Widget _scrollHandle() {
    return Center(
        child: Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: colorPrimary.withOpacity(0.1),
      ),
      height: 4,
      width: 40,
    ));
  }
}
