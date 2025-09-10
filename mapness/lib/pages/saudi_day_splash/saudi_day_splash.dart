import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/pages/stories/stories_page.dart';

@RoutePage()
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
