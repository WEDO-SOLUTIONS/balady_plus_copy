enum StoryTypes {
  route,
  network,
  onboarding,
  saudiDay,
  mekkahBase;

  static StoryTypes? fromFile(String file) => switch (file) {
        'route' => StoryTypes.route,
        'onboarding' => StoryTypes.onboarding,
        'saudiDay' => StoryTypes.saudiDay,
        'mekkahBase' => StoryTypes.mekkahBase,
        'network' => StoryTypes.network,
        _ => null,
      };
}

extension StoryTypesExtension on StoryTypes {
  String? get file => switch (this) {
        StoryTypes.route => 'route',
        StoryTypes.onboarding => 'onboarding',
        StoryTypes.saudiDay => 'saudiDay',
        StoryTypes.mekkahBase => 'mekkahBase',
        StoryTypes.network => 'network',
      };
}
