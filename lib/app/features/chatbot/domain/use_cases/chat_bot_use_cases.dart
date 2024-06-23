import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:balady_plus/app/features/chatbot/data/models/chat_bot_message_model.dart';
import 'package:balady_plus/app/features/chatbot/domain/entities/chat_bot_message_entities.dart';
import 'package:balady_plus/app/features/chatbot/domain/repositories/chat_bot_repository.dart';
import 'package:dartz/dartz.dart';

class SendQuestionMessageChatBot extends UseCase<ChatBotMessageModel, String> {
  final ChatBotRepository repository;

  SendQuestionMessageChatBot(this.repository);

  @override
  Future<Either<Failure, ChatBotMessageModel>> call(String params) async {
    return await repository.sendQuestionMessage(question: params);
  }
}

class SendQuestionMessageChatBotSSE extends UseCase<Stream, String> {
  final ChatBotRepository repository;

  SendQuestionMessageChatBotSSE(this.repository);

  @override
  Future<Either<Failure, Stream>> call(String params) async {
    return await repository.sendQuestionMessageSSE(question: params);
  }
}

// class SendQuestionMessageChatBot extends UseCase<ChatBotMessageModel, String> {
//   final ChatBotRepository repository;
//
//   SendQuestionMessageChatBot(this.repository);
//
//   @override
//   Future<Either<Failure, ChatBotMessageModel>> call(String params) async {
//     return await repository.sendQuestionMessage(question: params);
//   }
//
// }
