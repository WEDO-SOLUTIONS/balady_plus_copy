abstract class EventModel {
  final String nameEvent;
  final bool? status;
  final String? message;

  EventModel({
    required this.nameEvent,
    this.status,
    this.message,
  });

  Map<String, dynamic> toJson();
}
