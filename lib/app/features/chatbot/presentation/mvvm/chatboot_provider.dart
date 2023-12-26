import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';

import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/chatbot/data/models/chat_bot_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class ChatBotProvider extends BaseViewModel {
  final WebService repository;

  ScrollController scrollController = ScrollController();

  ValueNotifier<List<ChatBotMessage>> chatBotMessage =
  ValueNotifier<List<ChatBotMessage>>([]);

  ChatBotProvider(this.repository);

  Future sendQuestion(String question) async {
    isLoading = true;
    notifyListeners();
    Response? response;
    try {
      response = await repository.dio.post(
        ApiUrl.chatBot,
        data: {"question": question},
        options: Options(
          headers: {
            "Accept":"*/*"
          },
        ),
      );
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      isLoading = false;
      setMessage(ChatBotMessage(message: result['response'], isResponse: true));
      notifyListeners();
      return chatBotMessage;
    } on Exception catch (exception) {
      CommonFunctions.sendEvent(
        dioError: exception is DioException ? exception : null,
        response: response,
        ex: exception,
      );
      setMessage(
        ChatBotMessage(
          message: exception.toString(),
          isResponse: true,
          haveError: true,
        ),
      );
    } catch (exception) {
      CommonFunctions.sendEvent(
        dioError: null,
        response: response,
        ex: Exception(exception.toString()),
      );
      setMessage(
        ChatBotMessage(
          message: exception.toString(),
          isResponse: true,
          haveError: true,
        ),
      );
    }
    isLoading = false;
    notifyListeners();
    return chatBotMessage;
  }

  void setMessage(ChatBotMessage message) {
    chatBotMessage.value.add(message);
    chatBotMessage.notifyListeners();
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 150,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }
}
