import 'dart:async';
import 'dart:developer';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
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
  bool isClose = false;
  String? messageID;
  MessageChatBotProvider({
    required this.repository,
    required this.message,
    required this.scrollController,
  }) {
    if(message.value.answer.isEmpty) {
      sendQuestion(message.value.question);
    }
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
          print("STAAAART STREAM 11");
          if (!isClose) {
            String typeData = "";
            listen = stream.listen((messageType) {

              if(messageID == null)
              {
                messageID = messageType;
              }
              else {
                if (messageType.indexOf('\\') > 0 &&
                    messageType.indexOf('n') == -1) {
                  typeData =
                      messageType; // what are the steps to apply to a commercial license
                } else if (messageType.isNotEmpty) {
                  typeData += messageType;
                  String editMessage = typeData.replaceAll("\\n", "\n");
                  message.value = message.value.copyWith(
                      answer: "${message.value.answer}$editMessage",
                      messID: messageID
                  );
                  typeData = "";
                  isLoading = false;
                  notifyListeners();
                  message.notifyListeners();
                  scrollControllerAction();
                }
              }
            });
            listen!.onDone(() {
              message.value = message.value.copyWith(
                haveError: false,
              );
              isLoading = false;
              notifyListeners();

              listen!.cancel();
              scrollControllerAction();
            });
            listen!.onError((error) {
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
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
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
  Future sendFeedBack(String messID,bool like) async {

    isLoading = true;

    try {

      Either<Failure, bool> response;
      response = await repository.repository.sendFeedBack(messID: messID, like: like);
      response.fold(
            (error) {
          isLoading = false;
          message.value = message.value.copyWith(
              isLiked: null
          );
          message.notifyListeners();
          notifyListeners();
        },
            (sucessfull) {

          if(sucessfull)
          {
            message.value = message.value.copyWith(
                isLiked: like
            );

          }

          isLoading = false;
          message.notifyListeners();
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



}
