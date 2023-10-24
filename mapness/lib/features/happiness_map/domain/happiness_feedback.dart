import 'dart:collection';

class Coordinates {
  final double latitude;
  final double longitude;

  const Coordinates(this.latitude, this.longitude);
}

class HappinessState {
  final HappinessFeedback? feedback;
  final Coordinates coordinates;
  final String comment;
  final List<String> tags;

  const HappinessState({
    required this.comment,
    required this.feedback,
    required this.coordinates,
    required this.tags,
  }) : assert(feedback != null || tags.length == 0);

  HappinessState copyWith({
    HappinessFeedback? feedback,
    Coordinates? coordinates,
    List<String>? tags,
    String? comment,
  }) {
    return HappinessState(
      feedback: feedback ?? this.feedback,
      coordinates: coordinates ?? this.coordinates,
      tags: UnmodifiableListView(tags ?? this.tags),
      comment: comment ?? this.comment,
    );
  }
}

enum HappinessFeedback { like, dislike }
