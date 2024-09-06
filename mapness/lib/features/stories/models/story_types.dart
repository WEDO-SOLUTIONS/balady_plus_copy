enum StoryTypes {
  route,
  network,
  onboarding;

  static StoryTypes? fromFile(String file) => switch (file) {
        'route' => StoryTypes.route,
        'onboarding' => StoryTypes.onboarding,
        'network' => StoryTypes.network,
        _ => null,
      };
}

extension StoryTypesExtension on StoryTypes {
  String? get file => switch (this) {
        StoryTypes.route => 'route',
        StoryTypes.onboarding => 'onboarding',
        StoryTypes.network => 'network',
      };
}
