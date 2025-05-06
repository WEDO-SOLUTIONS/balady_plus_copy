import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

class ShowOnboardingButton extends ConsumerWidget {
  const ShowOnboardingButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => LabeledElevatedButton(
        onPressed: () {
          ref.read(appAnalyticsProvider).onboardingFlowStarted();
          context.pushRoute(OnboardRoute(type: StoryTypes.onboarding));
        },
        label: 'Show onboarding',
      );
}
