import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/pages/navigator_settings/components/language_pick_sheet.dart';

part 'language_picker.g.dart';

@TypedGoRoute<LanguagePickSheetRoute>(
  path: LanguagePickSheetRoute.path,
)
class LanguagePickSheetRoute extends GoRouteData {
  static const path = '/language_pick_sheet';

  const LanguagePickSheetRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  static void open(BuildContext context) {
    const route = LanguagePickSheetRoute();
    final router = GoRouter.of(context);
    final matches = router.routerDelegate.currentConfiguration.matches;
    if (matches.last.matchedLocation == path) {
      route.pushReplacement(context);
    } else {
      route.push(context);
    }
  }

  @override
  Page<void> buildPage(
    BuildContext context,
    GoRouterState state,
  ) =>
      CustomTransitionPage(
        fullscreenDialog: true,
        opaque: false,
        barrierColor: context.color.surfaceOverlayModal,
        barrierDismissible: true,
        transitionsBuilder: (_, animation, ___, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: const Offset(0.0, 0.0),
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        ),
        child: const LanguagePickSheet(),
      );
}

final $languagePickerRoutes = $appRoutes;
