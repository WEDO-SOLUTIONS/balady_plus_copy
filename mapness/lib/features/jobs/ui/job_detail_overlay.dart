import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/jobs/ui/job_detail_sheet.dart';

class JobDetailOverlay extends ConsumerStatefulWidget {
  final String jobId;
  const JobDetailOverlay({
    super.key,
    required this.jobId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _JobDetailOverlayState();
}

class _JobDetailOverlayState extends ConsumerState<JobDetailOverlay> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            JobDetailSheet(
              jobId: widget.jobId,
              biggestWidth: constraints.biggest.width,
              biggestHeight: constraints.biggest.height,
            ),
          ],
        );
      },
    );
  }
}
