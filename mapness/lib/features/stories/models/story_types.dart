enum StoryTypes {
  route,
  onboarding;

  static StoryTypes? fromFile(String file) => switch (file) {
        'route' => StoryTypes.route,
        'onboarding' => StoryTypes.onboarding,
        _ => null,
      };
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
