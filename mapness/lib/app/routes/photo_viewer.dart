import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/shared/routing/transculent_page.dart';
import 'package:mapness/shared/ui/photo_viewer/photo_viewer.dart';

part 'photo_viewer.g.dart';

@TypedGoRoute<PhotoViewerRoute>(
  path: PhotoViewerRoute.path,
)
class PhotoViewerRoute extends GoRouteData {
  const PhotoViewerRoute({required this.currentPhotoIndex, required this.photoPaths});

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  static const path = '/photo_viewer';
  final List<String>? photoPaths;
  final int currentPhotoIndex;

  static void open(GoRouter router, int currentPhotoIndex, List<String> photoPaths) {
    final route = PhotoViewerRoute(currentPhotoIndex: currentPhotoIndex, photoPaths: photoPaths);
    router.push(route.location);
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => TransculentPage(
        child: PhotoViewerWidget(
          photoPaths: photoPaths,
          currentPhotoIndex: currentPhotoIndex,
        ),
      );
}

final $photoViewerRoutes = $appRoutes;
