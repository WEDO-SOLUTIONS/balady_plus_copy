import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/pages/theme_splash/theme_splash_page.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

class ShowOnboardingButton extends ConsumerWidget {
  const ShowOnboardingButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => DebugCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DebugSectionHeader(
          icon: Icons.start_rounded,
          title: 'Onboarding',
          subtitle: 'Show app introduction flow',
        ),
        const SizedBox(height: 14),
        DebugButton(
          label: 'Show Onboarding',
          icon: Icons.slideshow_rounded,
          onPressed: () {
            rootNavigatorKey.currentContext!.pushRoute(OnboardRoute());
          },
        ),
      ],
    ),
  );
}

class ShowSaudiDayButton extends ConsumerWidget {
  const ShowSaudiDayButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => DebugCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DebugSectionHeader(
          icon: Icons.celebration_rounded,
          title: 'Saudi National Day',
          subtitle: 'Preview celebration splash screen',
          gradient: DebugTheme.gradientGreen,
        ),
        const SizedBox(height: 14),
        DebugButton(
          label: 'Show Splash Screen',
          icon: Icons.preview_rounded,
          gradient: DebugTheme.gradientGreen,
          onPressed: () {
            Navigator.of(rootNavigatorKey.currentContext!).push(
              MaterialPageRoute<void>(
                builder: (_) => const ThemeSplashPage(
                  theme: SpecialThemeMode.nationalDay,
                ),
                fullscreenDialog: true,
              ),
            );
          },
        ),
      ],
    ),
  );
}
