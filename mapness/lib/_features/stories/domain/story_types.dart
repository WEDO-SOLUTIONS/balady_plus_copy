enum StoryTypes {
  route,
}

extension StoryTypesExtension on StoryTypes {
  String get file {
    switch (this) {
      case StoryTypes.route:
        return 'route';
    }
  }
}
