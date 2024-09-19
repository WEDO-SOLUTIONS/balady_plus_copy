import 'package:equatable/equatable.dart';

class ChatBotMessageEntities extends Equatable {
  final String question;

  // final List<String> answerList;
  final String answer;

  final int sectionId;
  final String? messID;
  final bool haveError;

  final bool? isLiked;
  final DateTime timeStampSend;
  late final DateTime? timeStampReceived;

  ChatBotMessageEntities({
    required this.question,
    required this.answer,
    required this.haveError,
    required this.sectionId,
    this.messID,
    this.isLiked,
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
    messID,
    isLiked,
    timeStampReceived,
  ];

  ChatBotMessageEntities copyWith({
    final String? question,
    // final List<String>? answer,
    final String? answer,
    final String? messID,
    final bool? isLiked,
    final bool? haveError,
    final DateTime? timeStampReceived,
  }) {
    return ChatBotMessageEntities(
        question: question ?? this.question,
        answer: answer ?? this.answer,
        haveError: haveError ?? this.haveError,
        isLiked: isLiked ?? this.isLiked,
        timeStampReceived: timeStampReceived ?? this.timeStampReceived,
        timeStampSend: timeStampSend,
        messID: messID ??this.messID,
        sectionId: sectionId);
  }
}
