import 'package:flutter/material.dart';
import 'package:mapness/features/stories/models/story_types.dart';

class StoryTypeProvider extends InheritedWidget {
  final StoryTypes type;
  const StoryTypeProvider({
    required this.type,
    required super.child,
    super.key,
  });

  static StoryTypes of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<StoryTypeProvider>()!.type;

  @override
  bool updateShouldNotify(StoryTypeProvider oldWidget) => oldWidget.type != type;
}
