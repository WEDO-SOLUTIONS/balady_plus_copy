import 'package:flutter/material.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/features/stories/domain/story_types.dart';
import 'package:mapness/features/stories/stories.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

class ShowOnboardingButton extends StatelessWidget {
  const ShowOnboardingButton({super.key});

  @override
  Widget build(BuildContext context) => LabeledElevatedButton(
        onPressed: () {
          Stories.showOnboarding(
            rootNavigatorKey.currentContext!,
            StoryTypes.onboarding,
            'onboarding',
            onActionShowNextHistory: true,
          );
        },
        label: 'Show onboarding',
      );
}
