import 'package:flutter/material.dart';
import 'package:mapness/features/stories/models/story_types.dart';

class StoryArgsProvider extends InheritedWidget {
  final StoryTypes type;
  final void Function([int? index]) onClose;
  const StoryArgsProvider({
    required this.type,
    required this.onClose,
    required super.child,
    super.key,
  });

  static StoryArgsProvider of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<StoryArgsProvider>()!;

  @override
  bool updateShouldNotify(StoryArgsProvider oldWidget) => oldWidget.type != type;
}
