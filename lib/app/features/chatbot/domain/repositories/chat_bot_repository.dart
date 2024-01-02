

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/chatbot/data/models/chat_bot_message.dart';
import 'package:dartz/dartz.dart';

abstract class ChatBotRepository {


  Future<Either<Failure, ChatBotMessage>> sendQuestionMessage(String question);

}
