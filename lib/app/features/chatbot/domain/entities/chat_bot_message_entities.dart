import 'package:balady_plus/app/features/municipal_services/municipal_advisor/municipal_advisor_exports.dart';
import 'package:equatable/equatable.dart';

  class ChatBotMessageEntities extends Equatable {
  final String message;
  final bool isResponse;
  final bool haveError;
  final DateTime timeStamp;

  ChatBotMessageEntities({
    required this.message,
    required this.isResponse,
    required this.haveError ,
  }) : timeStamp = DateTime.now();

  @override
  List<Object?> get props => [
        message,
        isResponse,
        haveError,
        timeStamp,
      ];
}
