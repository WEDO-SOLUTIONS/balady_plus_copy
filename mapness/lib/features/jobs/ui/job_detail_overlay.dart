import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/jobs/providers/job_detail_provider.dart';
import 'package:mapness/features/jobs/ui/job_detail_sheet.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';

@RoutePage()
/// TODO(Ayat) check logic Ui
class JobDetailOverlayPage extends ConsumerStatefulWidget {
  const JobDetailOverlayPage({
    required this.jobId,
    super.key,
  });
  final String jobId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _JobDetailOverlayState();
}

class _JobDetailOverlayState extends ConsumerState<JobDetailOverlayPage> {
  @override
  Widget build(BuildContext context) {
    final detailJob = ref.watch(
      jobDetailProvider(
        id: widget.jobId,
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) => detailJob.maybeWhen(
        error: (_, __) => ErrorSheet(
          onRetry: () => ref.invalidate(jobDetailProvider(id: widget.jobId)),
        ),
        orElse: () => JobDetailSheet(
          jobId: widget.jobId,
          biggestWidth: constraints.biggest.width,
          biggestHeight: constraints.biggest.height,
        ),
      ),
    );
  }
}
