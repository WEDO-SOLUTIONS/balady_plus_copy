import 'package:balady_plus/app/features/chatbot/domain/entities/chat_bot_message_entities.dart';

class ChatBotMessageModel extends ChatBotMessageEntities {
  ChatBotMessageModel({
    required super.question,
    required super.answer,
    required super.sectionId,
    // super.isResponse = false,
    super.haveError = false,
  });
}
