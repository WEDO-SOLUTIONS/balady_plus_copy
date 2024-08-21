import 'event_model.dart';

class RequestApiModel extends EventModel {
  final String cUrl;

  RequestApiModel({
    required super.message,
    required super.nameEvent,
    required this.cUrl,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "responseBody": message,
      "cUrl": cUrl,
      "date": DateTime.now().toIso8601String(),
    };
  }
}
