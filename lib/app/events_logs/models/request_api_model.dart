import 'event_model.dart';

class RequestApiModel extends EventModel {
  final String url;
  final String verifyingKEY;
  final String body;

  RequestApiModel({
    required super.message,
    required super.nameEvent,
    required this.url,
    required this.body,
    required this.verifyingKEY,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "responseBody": message,
      "url": url,
      "requestBody": body,
      "verifyingKEY": verifyingKEY,
      "date": DateTime.now().toIso8601String(),
    };
  }
}
