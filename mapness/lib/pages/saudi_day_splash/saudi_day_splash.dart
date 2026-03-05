import 'package:flutter/material.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/pages/stories/stories_page.dart';

/// @deprecated Use [ThemeSplashPage] instead.
///
/// This page is deprecated and will be removed in a future release.
/// It has been replaced by the generic [ThemeSplashPage] which displays
/// splash screens for all themed modes.
///
/// **Migration:**
/// Use MaterialPageRoute with ThemeSplashPage instead of SaudiDaySplashRoute.
///
/// See: /mapness/lib/pages/theme_splash/theme_splash_page.dart
///
/// Note: @RoutePage removed because this page is no longer registered in app routes.
/// It remains only for backwards compatibility until complete removal.
@Deprecated('Use ThemeSplashPage instead. Will be removed in next release.')
class SaudiDaySplashPage extends StatelessWidget {
  const SaudiDaySplashPage({
    this.onClose,
    super.key,
  });

  final Function()? onClose;

  @override
  Widget build(BuildContext context) => StoriesPage(
        type: StoryTypes.saudiDay,
        onClose: onClose,
      );
}
