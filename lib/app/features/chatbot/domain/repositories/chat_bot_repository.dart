import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/chatbot/data/models/chat_bot_message_model.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/chat_refresh_session.dart';
import '../../data/models/chat_refresh_session.dart';
import '../../data/models/session_data.dart';
import '../../data/models/session_details.dart';

abstract class ChatBotRepository {
  Future<Either<Failure, ChatBotMessageModel>> sendQuestionMessage(
      {required String question});

  Future<Either<Failure, Stream>> sendQuestionMessageSSE(
      {required String question});

  Future<Either<Failure, bool>> chatBotIsEnabled();

  Future<Either<Failure, bool>> sendFeedBack(
      {required String messID, required bool like});

  Future<Either<Failure, List<SessionData>>> getSesionHistory(
      {required String id});
  Future<Either<Failure, SessionDetails>> getSessionDetails(
      {required String id});
  Future<Either<Failure, ChatRefreshSession>> refreshSession(
      {required String id});

  Future<Either<Failure, List<String>>> getPromptQuestions({required String userId});


  }
