import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/chatbot/domain/entities/chat_bot_message_entities.dart';
import 'package:balady_plus/app/features/chatbot/domain/use_cases/chat_bot_use_cases.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class MessageChatBotProvider extends BaseViewModel {
  final SendQuestionMessageChatBot repository;
  final ScrollController scrollController;
  final ValueNotifier<ChatBotMessageEntities> message;
  StreamSubscription? listen;

  MessageChatBotProvider({
    required this.repository,
    required this.message,
    required this.scrollController,
  }) {
    sendQuestion(message.value.question);
  }

  Future sendQuestion(String question) async {
    isLoading = true;
    notifyListeners();
    try {
      scrollControllerAction();
      message.value = message.value.copyWith(answer: '');
      Either<Failure, Stream> response;
      response = await repository.repository.sendQuestionMessageSSE(
        question: question,
      );
      response.fold(
        (error) {
          message.value = message.value.copyWith(
            answer: error is ServerFailure
                ? error.errorMessage
                : 'error_please_try_again_later'.tr(),
            haveError: true,
            timeStampReceived: DateTime.now(),
          );
          message.notifyListeners();
          if (isLoading != false) {
            isLoading = false;
            notifyListeners();
          }
          scrollControllerAction();
        },
        (stream) {
          String fullStream = "";
          if (!isClose) {
            listen = stream.listen((messageType) {
              String editMessage = messageType.replaceAll("\\n", "\n");
              //  String editMessage = messageType;
              message.value = message.value.copyWith(
                answer: "${message.value.answer}$editMessage",
                // answer: message.value.answer + [messageType]
              );
              fullStream = fullStream + messageType;

              isLoading = false;
              notifyListeners();

              message.notifyListeners();
              scrollControllerAction();
            });
            listen!.onDone(() {
              message.value = message.value.copyWith(
                haveError: false,
              );
              message.value = message.value
                  .copyWith(answer: fullStream.replaceAll("\\n", "\n"));
              isLoading = false;
              notifyListeners();
              listen!.cancel();
              scrollControllerAction();
            });
            listen!.onError((error) {
              print("on Erorr ${error}");

              // message.value.answer.add(error.toString());
              message.value = message.value.copyWith(
                answer: message.value.answer + error.toString(),
                haveError: true,
              );
              message.notifyListeners();
              isLoading = false;
              notifyListeners();
              listen!.cancel();
              scrollControllerAction();
            });
            message.value =
                message.value.copyWith(timeStampReceived: DateTime.now());
            message.notifyListeners();
            notifyListeners();
          }
        },
      );
      return message.value;
    } catch (exception) {
      print(exception);
      CommonFunctions.sendEvent(
        dioError: null,
        response: null,
        ex: Exception(exception.toString()),
      );
      message.value = message.value.copyWith(
        answer: 'error_please_try_again_later'.tr(),
        haveError: true,
        timeStampReceived: DateTime.now(),
      );
      message.notifyListeners();
    }
    isLoading = false;
    notifyListeners();
    return message.value;
  }

  bool isClose = false;
  void closeAnswer() {
    if (listen != null) {
      listen!.cancel();
    }
    message.value = message.value.copyWith(answer: ''.tr());
    isLoading = false;
    isClose = true;
    notifyListeners();
  }

  void scrollControllerAction() {
    if (scrollController.position.maxScrollExtent - 80 >
        scrollController.offset) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 20,
        curve: Curves.linear,
        duration: const Duration(milliseconds: 450),
      );
    }
  }
}
