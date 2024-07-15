enum StoryTypes {
  route,
  onboarding,
}

extension StoryTypesExtension on StoryTypes {
  String get file {
    switch (this) {
      case StoryTypes.route:
        return 'route';
      case StoryTypes.onboarding:
        return 'onboarding';
    }
  }
}
