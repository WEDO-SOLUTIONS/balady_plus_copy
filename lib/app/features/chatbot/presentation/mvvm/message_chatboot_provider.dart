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

  final ValueNotifier<ChatBotMessageEntities> message;
  StreamSubscription? listen;

  MessageChatBotProvider({
    required this.repository,
    required this.message,
    // required this.listen,
  }) {
    // ValueNotifier<ChatBotMessageEntities>()
    sendQuestion(message.value.question);
  }

  // Future sendQuestion(String question) async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     message.value = message.value.copyWith(
  //       answer: '',
  //     );
  //     Either<Failure, ChatBotMessageModel> response;
  //     response = await repository.repository.sendQuestionMessage(
  //       question: question,
  //     );
  //     response.fold(
  //       (error) {
  //         message.value = message.value.copyWith(
  //           answer: error is ServerFailure ? error.errorMessage : error.toString(),
  //           haveError: true,
  //           timeStampReceived: DateTime.now(),
  //         );
  //         message.notifyListeners();
  //         isLoading = false;
  //         notifyListeners();
  //       },
  //       (stream) {
  //         message.value = stream;
  //         message.notifyListeners();
  //         // listen = stream.listen((messageType) {
  //         //   message.value = message.value.copyWith(
  //         //     answer: "${message.value.answer} New Data Form Server  -> $messageType, \n",
  //         //   );
  //         //   message.notifyListeners();
  //         // });
  //         // listen!.onDone(() {
  //         //   isLoading = false;
  //         //   notifyListeners();
  //         //   listen!.cancel();
  //         // });
  //         // listen!.onError((error) {
  //         //   message.value = message.value.copyWith(
  //         //     answer: message.value.answer + error.toString(),
  //         //     haveError: true,
  //         //   );
  //         //   message.notifyListeners();
  //         //   isLoading = false;
  //         //   notifyListeners();
  //         //   listen!.cancel();
  //         // });
  //         // message.value = message.value.copyWith(
  //         //   timeStampReceived: DateTime.now(),
  //         // );
  //         message.notifyListeners();
  //         notifyListeners();
  //       },
  //     );
  //     return message.value;
  //   } catch (exception) {
  //     CommonFunctions.sendEvent(
  //       dioError: null,
  //       response: null,
  //       ex: Exception(exception.toString()),
  //     );
  //     message.value = message.value.copyWith(
  //       answer: exception.toString(),
  //       haveError: true,
  //       timeStampReceived: DateTime.now(),
  //     );
  //     message.notifyListeners();
  //   }
  //   isLoading = false;
  //   notifyListeners();
  //   return message.value;
  // }

  Future sendQuestion(String question) async {
    isLoading = true;
    notifyListeners();
    try {
      message.value = message.value.copyWith(
        answer: '',
      );
      Either<Failure, Stream> response;
      response = await repository.repository.sendQuestionMessageSSE(
        question: question,
      );
      response.fold(
        (error) {
          message.value = message.value.copyWith(
            answer: error is ServerFailure ? error.errorMessage : 'error_please_try_again_later'.tr(),
            // answer: [error is ServerFailure ? error.errorMessage : error.toString()],
            haveError: true,
            timeStampReceived: DateTime.now(),
          );
          message.notifyListeners();
          isLoading = false;
          notifyListeners();
        },
        (stream) {
          listen = stream.listen((messageType) {
            message.value = message.value.copyWith(
              answer: "${message.value.answer}$messageType",
              // answer: message.value.answer + [messageType]
            );
            message.notifyListeners();
          });
          listen!.onDone(() {
            message.value = message.value.copyWith(
              haveError: false,
            );
            isLoading = false;
            notifyListeners();
            listen!.cancel();
          });
          listen!.onError((error) {
            // message.value.answer.add(error.toString());
            message.value = message.value.copyWith(
              answer: message.value.answer + error.toString(),
              haveError: true,
            );
            message.notifyListeners();
            isLoading = false;
            notifyListeners();
            listen!.cancel();
          });
          message.value = message.value.copyWith(
            timeStampReceived: DateTime.now(),
          );
          message.notifyListeners();
          notifyListeners();
        },
      );
      return message.value;
    } catch (exception) {
      CommonFunctions.sendEvent(
        dioError: null,
        response: null,
        ex: Exception(exception.toString()),
      );
      message.value = message.value.copyWith(
        answer:  'error_please_try_again_later'.tr(),
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
      isLoading = false;
      notifyListeners();
    }
  }
}
