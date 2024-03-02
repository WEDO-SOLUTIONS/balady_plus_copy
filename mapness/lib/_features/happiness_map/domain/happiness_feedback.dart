import 'dart:collection';

class Coordinates {

  const Coordinates({required this.latitude, required this.longitude});
  const Coordinates.ltlg(this.latitude, this.longitude);
  final double latitude;
  final double longitude;
  static const Coordinates zero = Coordinates(latitude: 0, longitude: 0);
}

class HappinessState {

  const HappinessState({
    required this.comment,
    required this.feedback,
    required this.coordinates,
    required this.tags,
  }) : assert(feedback != null || tags.length == 0);
  final HappinessFeedback? feedback;
  final Coordinates coordinates;
  final String comment;
  final List<String> tags;

  HappinessState copyWith({
    HappinessFeedback? feedback,
    Coordinates? coordinates,
    List<String>? tags,
    String? comment,
  }) => HappinessState(
      feedback: feedback ?? this.feedback,
      coordinates: coordinates ?? this.coordinates,
      tags: UnmodifiableListView(tags ?? this.tags),
      comment: comment ?? this.comment,
    );
}

enum HappinessFeedback { like, dislike }
