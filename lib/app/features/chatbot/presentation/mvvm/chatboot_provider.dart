import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/chatbot/domain/entities/chat_bot_message_entities.dart';
import 'package:balady_plus/app/features/chatbot/domain/use_cases/chat_bot_use_cases.dart';
import 'package:balady_plus/app/features/chatbot/presentation/mvvm/message_chatboot_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:balady_plus/app/core/services/local/shared_prefs_manager.dart';
import 'package:uuid/uuid.dart';

import 'package:balady_plus/app/events_logs/balady_logs.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../data/models/chat_refresh_session.dart';
import '../../data/models/session_data.dart';
import '../../data/models/session_details.dart';

class ChatBotProvider extends BaseViewModel {
  final SendQuestionMessageChatBot repository;
  final int sectionId;

  ScrollController scrollController = ScrollController();

  ValueNotifier<List<MessageChatBotProvider>> chatBotMessage =
      ValueNotifier<List<MessageChatBotProvider>>([]);

  List<SessionData> lstOldSession = [];

  List<History> lstHistory = [];
  bool isEnabled = false;
  bool isLoadingEnabled = false;

  bool isOpenedFromHistory = false;

  String? selectedOldSession;

  ChatBotProvider(this.repository, {required this.sectionId}) {
    chatBotIsEnabled();
  }

  Future sendQuestion(String question) async {
    if (isOpenedFromHistory == true && selectedOldSession != null) {
      refershSesion(selectedOldSession!, question);
    } else {
      isLoading = true;
      notifyListeners();
      try {
        MessageChatBotProvider provider = MessageChatBotProvider(
          repository: repository,
          message: ValueNotifier<ChatBotMessageEntities>(
            ChatBotMessageEntities(
              question: question,
              answer: '',
              haveError: false,
              sectionId: sectionId,
            ),
          ),
          scrollController: scrollController,
        );

        chatBotMessage.value.add(provider);
        provider.addListener(() {
          if (!provider.isLoading) {
            isLoading = false;
            notifyListeners();
          }
        });
        return chatBotMessage;
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }
      isLoading = false;
      notifyListeners();
      return chatBotMessage;
    }
  }

  Future chatBotIsEnabled() async {
    isLoadingEnabled = true;
    notifyListeners();
    try {
      Either<Failure, bool> response =
          await repository.repository.chatBotIsEnabled();
      response.fold(
        (error) {
          isLoadingEnabled = false;
          isEnabled = false;
          notifyListeners();
        },
        (isEnabled) {
          isLoadingEnabled = false;
          this.isEnabled = isEnabled;
          sharedPrefs.setChatbotSessionId(Uuid().v4());
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
    isLoadingEnabled = false;
    notifyListeners();
    return;
  }

  Future refershSesion(String id, String question) async {
    if (id.isEmpty) return;
    isLoading = true;
    notifyListeners();
    try {
      Either<Failure, dynamic> response;
      response = await repository.repository.refreshSession(id: id);
      response.fold(
        (error) {
          isLoading = false;
          isOpenedFromHistory = false;
          notifyListeners();
        },
        (res) {
          if ((res as ChatRefreshSession).result?.sessionId != null &&
              res.result!.sessionId!.isNotEmpty) {
            isOpenedFromHistory = false;
            sharedPrefs.setChatbotSessionId(res.result!.sessionId!);
            isLoading = false;
            notifyListeners();

            sendQuestion(question);
          }
        },
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    isLoading = false;
    notifyListeners();
  }

  Future getSesionHistory(String id) async {
    if (id.isEmpty) return;
    isLoading = true;
    //notifyListeners();
    try {
      Either<Failure, dynamic> response;

      response = await repository.repository.getSesionHistory(id: id);
      response.fold(
        (error) {
          isLoading = false;
          isOpenedFromHistory = false;
          notifyListeners();
        },
        (res) {
          isLoading = false;
          lstOldSession = res;
          notifyListeners();
        },
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    isLoading = false;
    notifyListeners();
  }

  Future getSesionDetails(String selectedSessionID) async {
    if (selectedSessionID == null) return;
    isLoading = true;
    notifyListeners();
    try {
      Either<Failure, dynamic> response;
      response =
          await repository.repository.getSessionDetails(id: selectedSessionID!);
      response.fold(
        (error) {
          isLoading = false;
          notifyListeners();
        },
        (res) {
          isLoading = false;
          notifyListeners();
          if (res != null) {
            NavigationService.navigatorKey.currentState
                ?.pushReplacementNamed(RouteName.chatbot, arguments: res);
          }
        },
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    isLoading = false;
    notifyListeners();
  }

  void intaiteChat(SessionDetails? res) {
    isOpenedFromHistory = true;
    if (res != null && (res).history != null) {
      selectedOldSession = res.sessionId;

      chatBotMessage.value.clear();
      lstHistory = (res as SessionDetails).history!;

      for (var index = 0; index < lstHistory.length;) {
        String question = lstHistory[index].content!;
        String answer = lstHistory[index + 1].content!.replaceAll("\\n", "\n");
        MessageChatBotProvider provider = MessageChatBotProvider(
          repository: repository,
          message: ValueNotifier<ChatBotMessageEntities>(
            ChatBotMessageEntities(
                question: question,
                answer: answer,
                haveError: false,
                messID: lstHistory[index + 1].messageID,
                isLiked: lstHistory[index + 1].messageFeedBack,
                sectionId: sectionId),
          ),
          scrollController: scrollController,
        );

        chatBotMessage.value.add(provider);
        index = index + 2;
      }
    }
  }
}
