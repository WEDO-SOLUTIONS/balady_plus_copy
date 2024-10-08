import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mapness/app/app_routes.gr.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

class ShowOnboardingButton extends StatelessWidget {
  const ShowOnboardingButton({super.key});

  @override
  Widget build(BuildContext context) => LabeledElevatedButton(
        onPressed: () => context.pushRoute(OnboardRoute(type: StoryTypes.onboarding)),
        label: 'Show onboarding',
      );
}
