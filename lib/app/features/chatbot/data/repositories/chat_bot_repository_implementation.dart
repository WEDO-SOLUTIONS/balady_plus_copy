import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/features/chatbot/data/data_sources/chat_bot_data_sources.dart';
import 'package:balady_plus/app/features/chatbot/data/models/chat_bot_message_model.dart';
import 'package:balady_plus/app/features/chatbot/domain/repositories/chat_bot_repository.dart';
import 'package:dartz/dartz.dart';

class ChatBotRepositoryImplementation implements ChatBotRepository {
  final ChatBotDataSources remoteDataSource;

  ChatBotRepositoryImplementation(this.remoteDataSource);

  @override
  Future<Either<Failure, ChatBotMessageModel>> sendQuestionMessage(
      {required String question}) async {
    try {
      final response = await remoteDataSource.sendQuestionMessage(
        question: question,
      );
      return Right(response);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
