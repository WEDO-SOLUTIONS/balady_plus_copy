import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/chatbot/data/models/chat_bot_message_model.dart';
import 'package:balady_plus/app/features/chatbot/domain/entities/chat_bot_message_entities.dart';
import 'package:balady_plus/app/features/chatbot/domain/use_cases/chat_bot_use_cases.dart';
import 'package:balady_plus/app/features/chatbot/presentation/mvvm/message_chatboot_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';

class ChatBotProvider extends BaseViewModel {
  final SendQuestionMessageChatBot repository;

  ScrollController scrollController = ScrollController();

  // ValueNotifier<List<ChatBotMessageEntities>> chatBotMessage =
  //     ValueNotifier<List<ChatBotMessageEntities>>([]);

  ValueNotifier<List<MessageChatBotProvider>> chatBotMessage = ValueNotifier<
      List<MessageChatBotProvider>>([]);

  // StreamSubscription? listen;

  ChatBotProvider(this.repository);

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
          ),
        ),
      );

      chatBotMessage.value.add(provider);
      provider.addListener(() {
        if (!provider.isLoading) {
          isLoading = false;
          notifyListeners();
        }

        if(scrollController.position.maxScrollExtent >= scrollController.offset) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent + 200,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 500),
          );
        }
      });
      return chatBotMessage;
    } catch (exception) {
      CommonFunctions.sendEvent(
        dioError: null,
        response: null,
        ex: Exception(exception.toString()),
      );
      // setMessage(
      //   ChatBotMessageModel(
      //     message: exception.toString(),
      //     isResponse: true,
      //     haveError: true,
      //   ),
      // );
    }
    isLoading = false;
    notifyListeners();
    return chatBotMessage;
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
