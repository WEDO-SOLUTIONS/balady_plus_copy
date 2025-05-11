import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/shared_prefs_manager.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/chatbot/domain/use_cases/chat_bot_use_cases.dart';
import 'package:dartz/dartz.dart';

class PromptQuestionsProvider extends BaseViewModel {
  final SendQuestionMessageChatBot repository;

  //  for the first time
  List<String> listQuestions = [];



  List<String> listQuestionsFollowUp = [];

  PromptQuestionsProvider({required this.repository}) {
    getPromptQuestions();
  }

  Future getPromptQuestions() async {
    notifyListeners();
    try {
      Either<Failure, List<String>> response =
          await repository.repository.getPromptQuestions(
        userId: CommonProperties.userInfo?.idNo ?? '',
      );
      response.fold(
        (error) {
          isLoading = false;
          notifyListeners();
        },
        (questions) {
          isLoading = false;
          listQuestions = questions;
          notifyListeners();
        },
      );
      return;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      errorMessage = error.toString();
    }
    isLoading = false;
    notifyListeners();
    return;
  }

  // for follow up cull after 4 questions
  Future getPromptQuestionsFollowUp() async {
    notifyListeners();
    try {
      Either<Failure, List<String>> response =
          await repository.repository.getPromptQuestionsFollowUp(
        sessionId: sharedPrefs.getChatbotSessionId() ?? '',
      );
      response.fold(
        (error) {
          isLoading = false;
          notifyListeners();
        },
        (questions) {
          isLoading = false;
          listQuestionsFollowUp = questions;
          notifyListeners();
        },
      );
      return;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      errorMessage = error.toString();
    }
    isLoading = false;
    notifyListeners();
    return;
  }

}
