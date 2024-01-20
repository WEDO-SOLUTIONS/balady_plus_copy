import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/jobs/ui/job_detail_sheet.dart';

class JobDetailOverlay extends ConsumerStatefulWidget {
  final String jobId;
  const JobDetailOverlay({
    required this.jobId,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _JobDetailOverlayState();
}

class _JobDetailOverlayState extends ConsumerState<JobDetailOverlay> {
  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => JobDetailSheet(
          jobId: widget.jobId,
          biggestWidth: constraints.biggest.width,
          biggestHeight: constraints.biggest.height,
        ),
      );
}
