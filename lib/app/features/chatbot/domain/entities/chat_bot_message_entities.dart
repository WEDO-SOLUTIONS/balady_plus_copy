import 'package:equatable/equatable.dart';

class ChatBotMessageEntities extends Equatable {
  final String question;

  // final List<String> answerList;
  final String answer;

  final int sectionId;

  final bool haveError;
  final DateTime timeStampSend;
  late final DateTime? timeStampReceived;

  ChatBotMessageEntities({
    required this.question,
    required this.answer,
    required this.haveError,
    required this.sectionId,
    this.timeStampReceived,
    timeStampSend,
  }) : timeStampSend = timeStampSend ?? DateTime.now();

  @override
  List<Object?> get props => [
        question,
        answer.length,
        haveError,
        sectionId,
        timeStampSend,
        timeStampReceived,
      ];

  ChatBotMessageEntities copyWith({
    final String? question,
    // final List<String>? answer,
    final String? answer,
    final bool? haveError,
    final DateTime? timeStampReceived,
  }) {
    return ChatBotMessageEntities(
        question: question ?? this.question,
        answer: answer ?? this.answer,
        haveError: haveError ?? this.haveError,
        timeStampReceived: timeStampReceived ?? this.timeStampReceived,
        timeStampSend: timeStampSend,
        sectionId: sectionId);
  }
}
