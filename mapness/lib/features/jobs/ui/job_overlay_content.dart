import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/jobs/providers/jobs_statistic_provider.dart';
import 'package:mapness/features/jobs/ui/job_map_bottom_sheet.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';

class JobOverlayContent extends ConsumerStatefulWidget {
  const JobOverlayContent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _JobOverlayContentState();
}

class _JobOverlayContentState extends ConsumerState<JobOverlayContent> {
  @override
  Widget build(BuildContext context) {
    final jobsStatistic = ref.watch(jobStatisticProvider);

    return LayoutBuilder(
      builder: (context, constraints) => jobsStatistic.maybeWhen(
        error: (_, __) => ErrorSheet(
          onRetry: () => ref.invalidate(jobStatisticProvider),
        ),
        orElse: () => JobMapBottomSheet(
          biggestWidth: constraints.biggest.width,
          biggestHeight: constraints.biggest.height,
        ),
      ),
    );
  }
}
