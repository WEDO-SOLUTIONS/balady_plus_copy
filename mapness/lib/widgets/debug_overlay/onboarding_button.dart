import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

class ShowOnboardingButton extends ConsumerWidget {
  const ShowOnboardingButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => LabeledElevatedButton(
        onPressed: () {
          rootNavigatorKey.currentContext!.pushRoute(OnboardRoute());
        },
        label: 'Show onboarding',
      );
}

class ShowSaudiDayButton extends ConsumerWidget {
  const ShowSaudiDayButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => LabeledElevatedButton(
        onPressed: () {
          rootNavigatorKey.currentContext!.pushRoute(SaudiDaySplashRoute());
        },
        label: 'Show saudi day splash screen',
      );
}
