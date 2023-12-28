import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:balady_plus/app/features/chatbot/data/models/chat_bot_message.dart';
import 'package:balady_plus/app/features/chatbot/domain/repositories/chat_bot_repository.dart';
import 'package:dartz/dartz.dart';


class SendQuestionMessageChatBot extends UseCase<ChatBotMessage, String> {
  final ChatBotRepository repository;

  SendQuestionMessageChatBot(this.repository);

  @override
  Future<Either<Failure, ChatBotMessage>> call(String params) async {
    return await repository.sendQuestionMessage(params);
  }
}
