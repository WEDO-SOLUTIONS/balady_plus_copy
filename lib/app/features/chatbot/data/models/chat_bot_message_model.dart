import 'package:balady_plus/app/features/chatbot/domain/entities/chat_bot_message_entities.dart';

class ChatBotMessageModel extends ChatBotMessageEntities {



  ChatBotMessageModel({
    required super.message,
    super.isResponse = false,
    super.haveError = false,
  });


}
