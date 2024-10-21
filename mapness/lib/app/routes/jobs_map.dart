import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/features/jobs/ui/job_detail_overlay.dart';
import 'package:mapness/features/jobs/ui/job_overlay_content.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'jobs_map.g.dart';

@TypedGoRoute<JobsMapRoute>(
  path: '/jobs_map',
)
class JobsMapRoute extends GoRouteData {
  const JobsMapRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => const TransculentPage(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: JobOverlayContentPage(),
      ),
    );
}

@TypedGoRoute<JobsMapDetail>(
  path: '/job/:jobId/detail',
)
class JobsMapDetail extends GoRouteData {

  JobsMapDetail({required this.jobId});
  final String jobId;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => TransculentPage(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: JobDetailOverlayPage(jobId: jobId),
      ),
    );
}

final $jobsMapRoutes = $appRoutes;
