import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/jobs/ui/job_map_bottom_sheet.dart';

class JobOverlayContent extends ConsumerStatefulWidget {
  const JobOverlayContent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _JobOverlayContentState();
}

class _JobOverlayContentState extends ConsumerState<JobOverlayContent> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            JobMapBottomSheet(
              biggestWidth: constraints.biggest.width,
              biggestHeight: constraints.biggest.height,
            ),
          ],
        );
      },
    );
  }
}
