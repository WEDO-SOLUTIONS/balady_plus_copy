

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/chatbot/domain/entities/chat_bot_message_entities.dart';
import 'package:dartz/dartz.dart';

abstract class ChatBotRepository {


  Future<Either<Failure, ChatBotMessageEntities>> sendQuestionMessage( {required String question});

}
