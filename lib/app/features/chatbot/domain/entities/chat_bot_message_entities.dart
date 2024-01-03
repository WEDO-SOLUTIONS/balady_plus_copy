import 'package:equatable/equatable.dart';

class ChatBotMessageEntities extends Equatable {
  final String question;
  final String answer;

  final bool haveError;
  final DateTime timeStampSend;
  late final DateTime? timeStampReceived;

  ChatBotMessageEntities({
    required this.question,
    required this.answer,
    required this.haveError,
    this.timeStampReceived,
    timeStampSend,
  }) : timeStampSend = timeStampSend ?? DateTime.now();

  @override
  List<Object?> get props => [
        question,
        answer,
        haveError,
        timeStampSend,
        timeStampReceived,
      ];

  ChatBotMessageEntities copyWith({
    final String? question,
    final String? answer,
    final bool? haveError,
    final DateTime? timeStampReceived,
  }) {
    return ChatBotMessageEntities(
      question: question ?? this.question,
      answer: answer ?? this.answer,
      haveError: haveError ?? this.haveError,
      timeStampReceived: timeStampReceived ?? this.timeStampReceived,
      timeStampSend: timeStampSend
    );
  }
}
