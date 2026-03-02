import 'event_model.dart';

class ErrorExceptionModel extends EventModel {
  final String stackTrace;

  ErrorExceptionModel({
    required super.message,
    required super.nameEvent,
    required this.stackTrace,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "error": message,
      "stackTrace": stackTrace,
      "date": DateTime.now().toIso8601String(),
    };
  }
}
