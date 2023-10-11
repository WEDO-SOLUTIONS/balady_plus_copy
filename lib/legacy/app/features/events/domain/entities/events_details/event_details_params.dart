class EventDetailsParams {
  String? key;
  EventDetailsParams({this.key});

  EventDetailsParams copyWith({
    String? key,
  }) {
    return EventDetailsParams(
      key: key ?? this.key,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (key != null) "Key": key,
    };
  }
}
