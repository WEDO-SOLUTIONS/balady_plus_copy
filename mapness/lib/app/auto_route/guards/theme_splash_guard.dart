import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/features/special_themes/core/theme_splash_config.dart';
import 'package:mapness/features/special_themes/core/theme_splash_state.dart';
import 'package:mapness/pages/theme_splash/theme_splash_page.dart';

/// Generic guard that shows themed splash screens based on the current [SpecialThemeMode].
///
/// Replaces the hardcoded [SaudiDaySplashGuard] with a centralized, theme-aware approach.
///
/// **How it works:**
/// 1. Reads current theme from [specialThemeModeProvider]
/// 2. Checks if theme has splash enabled via [ThemeSplashConfig]
/// 3. If enabled and not shown yet, redirects to [ThemeSplashRoute]
/// 4. After viewing, marks splash as shown via [ThemeSplashState]
///
/// **Persistence:**
/// Uses [SplashPersistenceStrategy] from theme config to determine how often splash is shown:
/// - `onceEver`: Show once in user's lifetime
/// - `oncePerActivationPeriod`: Show once per activation period (e.g., once per Ramadan season)
/// - `oncePerDay`: Show once per day during theme period
/// - `always`: Always show (for testing)
final class ThemeSplashGuard extends AutoRouteGuard {
  const ThemeSplashGuard(this.ref);

  final Ref ref;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // 1. Get current theme
    final currentTheme = ref.read(specialThemeModeProvider);
    final splashConfig = currentTheme.splashConfig;

    // 2. Check if current theme has splash enabled
    if (!splashConfig.enabled) {
      resolver.next();
      return;
    }

    // 3. Check if splash has been shown for this theme
    final splashState = ref.read(themeSplashStateProvider.notifier);
    if (!splashState.hasShownSplashFor(currentTheme)) {
      // 4. Let the main navigation complete first, then show splash on top
      // This ensures auto_route navigation isn't blocked
      resolver.next();

      // 5. Show themed splash screen after navigation completes
      // Using addPostFrameCallback to ensure the navigator is ready
      // Using rootNavigatorKey to access the main navigator
      // Mark splash as shown immediately to avoid ref disposal issues in callback
      splashState.markSplashShown(currentTheme);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final navigator = rootNavigatorKey.currentState;
        if (navigator != null) {
          navigator.push(
            MaterialPageRoute<void>(
              builder: (context) => ThemeSplashPage(
                theme: currentTheme,
                // Navigation handled by StoriesPage via useNavigatorPop
              ),
              fullscreenDialog: true,
            ),
          );
        }
      });
    } else {
      // Splash already shown for this theme, continue navigation
      resolver.next();
    }
  }
}
