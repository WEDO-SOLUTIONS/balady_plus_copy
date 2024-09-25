import 'event_model.dart';

class SimpleEventModel extends EventModel {
  SimpleEventModel({required super.nameEvent, super.message});

  @override
  Map<String, dynamic> toJson() => {
        if (message?.isNotEmpty ?? false) 'errorMessage': message,
      };
}
