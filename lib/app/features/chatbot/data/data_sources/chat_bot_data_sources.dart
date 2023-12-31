import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/chatbot/data/models/chat_bot_message_model.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

abstract class ChatBotDataSources {
  Future<ChatBotMessageModel> sendQuestionMessage({required String question});
}

class ChatBotDataSourcesImplementation extends ChatBotDataSources {
  final WebService webService;

  ChatBotDataSourcesImplementation({required this.webService});

  @override
  Future<ChatBotMessageModel> sendQuestionMessage({required String question}) async {
    var response;
    try {
      DateTime dateSendData = DateTime.now();
      response = await webService.dio.post(
        ApiUrl.chatBot,
        data: {"question": question},
        options: Options(
          headers: {"Accept": "*/*"},
        ),
      );
      DateTime dateGetData = DateTime.now();
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      var dataEvent = {
        "Question": question,
        "Answer": result['response'],
        "Duration_Seconds": dateGetData.difference(dateSendData).inSeconds,
        "Duration_Milliseconds": dateGetData.difference(dateSendData).inMilliseconds,
      };
      CommonFunctions.sendUXCamEventWithProperties(
        UXCamEvents.sendQuestionChatBot,
        dataEvent,
      );
      return ChatBotMessageModel(message: result['response'], isResponse: true);
    } on DioError catch (error) {
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: ex.toString(),
          ),
          response: response,
        );
      }
    }
  }
}
