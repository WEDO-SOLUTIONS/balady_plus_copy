import 'package:flutter/material.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/app/routes/stories.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

class ShowOnboardingButton extends StatelessWidget {
  const ShowOnboardingButton({super.key});

  @override
  Widget build(BuildContext context) => LabeledElevatedButton(
        onPressed: () => StoriesRoute.openOnboarding(rootNavigatorKey.currentContext!),
        label: 'Show onboarding',
      );
}
