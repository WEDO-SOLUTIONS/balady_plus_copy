import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/features/stories/ui/stories_page.dart';

@RoutePage()
class OnboardPage extends StatelessWidget {
  const OnboardPage({
    required this.type,
    required this.onClose,
    super.key,
  });

  final StoryTypes type;
  final Function() onClose;

  @override
  Widget build(BuildContext context) => StoriesPage(
        type: type,
        onClose: onClose,
      );
}
