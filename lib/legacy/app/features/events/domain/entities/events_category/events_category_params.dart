class EventsCategoryParams {
  int? key;

  EventsCategoryParams({this.key});

  EventsCategoryParams copyWith({
    int? key,
  }) {
    return EventsCategoryParams(
      key: key ?? this.key,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "Key": key,
    };
  }
}
