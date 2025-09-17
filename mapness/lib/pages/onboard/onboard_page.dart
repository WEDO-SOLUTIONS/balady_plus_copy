import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/pages/stories/stories_page.dart';

@RoutePage()
class OnboardPage extends StatelessWidget {
  const OnboardPage({
    this.onClose,
    super.key,
  });

  final Function()? onClose;

  @override
  Widget build(BuildContext context) => StoriesPage(
        type: StoryTypes.onboarding,
        onClose: onClose,
      );
}
