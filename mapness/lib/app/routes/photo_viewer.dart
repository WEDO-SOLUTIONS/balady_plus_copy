import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/shared/routing/transculent_page.dart';
import 'package:mapness/shared/ui/photo_viewer/photo_viewer.dart';

part 'photo_viewer.g.dart';

@TypedGoRoute<PhotoViewerRoute>(
  path: PhotoViewerRoute.path,
)
class PhotoViewerRoute extends GoRouteData {
  static const path = '/photo-viewer';
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  const PhotoViewerRoute({required this.currentPhotoIndex, required this.photoPaths});


  final List<String>? photoPaths;
  final int currentPhotoIndex;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => TransculentPage(
        child: PhotoViewer(
          photoPaths: photoPaths,
          currentPhotoIndex: currentPhotoIndex,
        ),
      );
}

final $photoViewerRoutes = $appRoutes;
