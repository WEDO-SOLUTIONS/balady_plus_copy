import 'dart:async';

import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/chatbot/data/data_sources/chat_bot_data_sources.dart';
import 'package:balady_plus/app/features/chatbot/data/models/chat_bot_message_model.dart';
import 'package:balady_plus/app/features/chatbot/domain/repositories/chat_bot_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

import '../models/session_data.dart';
import '../models/session_details.dart';

///////////////////////////////////////////////////

class ChatBotRepositoryImplementation implements ChatBotRepository {
  final ChatBotDataSources remoteDataSource;

  ChatBotRepositoryImplementation(this.remoteDataSource);

  @override
  Future<Either<Failure, ChatBotMessageModel>> sendQuestionMessage(
      {required String question}) async {
    try {
      // DateTime dateSendData = DateTime.now();
      final stream = await remoteDataSource.sendQuestionMessage(
        question: question,
      );

      //////// Track Event
      // Map<String,dynamic> dataEvent = {"Question": question,'Answer':''};
      // Duration duration = DateTime.now().difference(dateSendData);
      // dataEvent["Answer_Response_Duration"] = duration.inMilliseconds;
      // StreamSubscription listen =  stream.listen((message) {
      //   dataEvent['Answer'] += message;
      // });
      // listen.onDone(() => _sendEvent(dateSendData,dataEvent));
      // listen.onError((error) => _sendEvent(dateSendData,dataEvent));
      return Right(stream);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, Stream>> sendQuestionMessageSSE(
      {required String question}) async {
    try {
      DateTime dateSendData = DateTime.now();
      final stream = await remoteDataSource.sendQuestionMessageSSE(
        question: question,
      );
      //////// Track Event
      // Map<String,dynamic> dataEvent = {"Question": question,'Answer':''};
      // Duration duration = DateTime.now().difference(dateSendData);
      // dataEvent["Answer_Response_Duration"] = duration.inMilliseconds;
      // StreamSubscription listen =  stream.listen((message) {
      //   dataEvent['Answer'] += message;
      // });
      // listen.onDone(() => _sendEvent(dateSendData,dataEvent));
      // listen.onError((error) => _sendEvent(dateSendData,dataEvent));
      return Right(stream);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, bool>> chatBotIsEnabled() async {
    try {
      final isEnabled = await remoteDataSource.chatBotIsEnabled();
      return Right(isEnabled);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, bool>> sendFeedBack({required String messID, required bool like}) async {

    try {
      final isEnabled = await remoteDataSource.sendFeedBack(messID: messID, like: like);
      return Right(isEnabled);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure,  List<SessionData>>> getSesionHistory({required String id}) async {

    try {
      final data = await remoteDataSource.getSessionHistory( id:id );
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage));
    }
  }


  @override
  Future<Either<Failure, SessionDetails>> getSessionDetails(
      {required String id}) async {

    try {
      final data = await remoteDataSource.getSessionDetails( id:id );
      return Right(data!);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage));
    }
  }




}
