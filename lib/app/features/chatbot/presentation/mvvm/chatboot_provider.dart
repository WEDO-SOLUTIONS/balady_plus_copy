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

class ChatBotProvider extends BaseViewModel {
  final SendQuestionMessageChatBot repository;
  final int sectionId;

  ScrollController scrollController = ScrollController();

  ValueNotifier<List<MessageChatBotProvider>> chatBotMessage =
      ValueNotifier<List<MessageChatBotProvider>>([]);

  bool isEnabled = false;
  bool isLoadingEnabled = false;

  ChatBotProvider(this.repository, {required this.sectionId}) {
    chatBotIsEnabled();
  }

  Future sendQuestion(String question) async {
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

        /* if (scrollController.position.maxScrollExtent >
            scrollController.offset) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent + 100,
            curve: Curves.linear,
            duration: const Duration(milliseconds: 600),
          );
        }*/
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
      // setMessage(
      //   ChatBotMessageModel(
      //     message: error.toString(),
      //     isResponse: true,
      //     haveError: true,
      //   ),
      // );
    }
    isLoading = false;
    notifyListeners();
    return chatBotMessage;
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

// void setMessage(ChatBotMessageEntities message) {
//   chatBotMessage.value.add(message);
//   chatBotMessage.notifyListeners();
//   scrollController.animateTo(
//     scrollController.position.maxScrollExtent + 150,
//     curve: Curves.easeOut,
//     duration: const Duration(milliseconds: 300),
//   );
// }
}
