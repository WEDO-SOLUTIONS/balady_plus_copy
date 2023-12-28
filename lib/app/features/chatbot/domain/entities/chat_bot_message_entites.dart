import 'package:balady_plus/app/features/municipal_services/municipal_advisor/municipal_advisor_exports.dart';
import 'package:equatable/equatable.dart';

class ChatBotMessage extends Equatable {
  final String message;
  final bool isResponse;
  final bool haveError;
  final DateTime timeStamp;

  ChatBotMessage({
    required this.message,
    this.isResponse = false,
    this.haveError = false,
  }) : timeStamp = DateTime.now();

  @override
  List<Object?> get props => [
        message,
        isResponse,
        haveError,
        timeStamp,
      ];
}
