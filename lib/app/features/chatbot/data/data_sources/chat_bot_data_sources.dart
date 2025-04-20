import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/chatbot/data/models/chat_bot_message_model.dart';
import 'package:dio/dio.dart' show Options, ResponseType, Response, DioError;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/services/local/shared_prefs_manager.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

import '../models/chat_refresh_session.dart';
import '../models/chat_refresh_session.dart';
import '../models/session_data.dart';
import '../models/session_details.dart';

abstract class ChatBotDataSources {
  Future<Stream> sendQuestionMessageSSE({required String question});

  Future<ChatBotMessageModel> sendQuestionMessage({required String question});

  Future<bool> chatBotIsEnabled();

  Future<bool> sendFeedBack({required String messID, required bool like});

  Future<dynamic> getSessionHistory({required String id});

  Future<SessionDetails?> getSessionDetails({required String id});

  Future<ChatRefreshSession?> refreshSession({required String id});

  Future<List<String>> getPromptQuestions({required String userId});
}

class ChatBotDataSourcesImplementation extends ChatBotDataSources {
  final WebService webService;

  ChatBotDataSourcesImplementation({required this.webService});

  @override
  Future<bool> chatBotIsEnabled() async {
    Response? response;
    try {
      response = await webService.dio.get(ApiUrl.chatBotEnabled);
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      return result['isEnabled'];
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<ChatBotMessageModel> sendQuestionMessage(
      {required String question}) async {
    Response? response;
    try {
      DateTime dateSendData = DateTime.now();
      response = await webService.dio.post(
        ApiUrl.chatBotStream,
        data: {"question": question},
        options: Options(
          headers: {"Accept": "*/*"},
          // responseType: ResponseType.stream,
        ),
      );
      DateTime dateGetData = DateTime.now();
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      var dataEvent = {
        "Question": question,
        "Answer": result['response'],
        "Duration_Seconds": dateGetData.difference(dateSendData).inSeconds,
        "Duration_Milliseconds":
            dateGetData.difference(dateSendData).inMilliseconds,
      };
      // CommonFunctions.sendUXCamEventWithProperties(
      //   UXCamEvents.sendQuestionChatBot,
      //   dataEvent,
      // );
      return ChatBotMessageModel(
        answer: result['response'],
        question: question,
        sectionId: 1000000000000,
      );
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<Stream> sendQuestionMessageSSE({required String question}) async {
    Response? response;
    try {
      response = await webService.dio.post(
        ApiUrl.chatBotStream,
        data: {"question": question},
        options: Options(
          headers: {
            "Accept": "*/*",
            "sessionId": sharedPrefs.getChatbotSessionId(),
            "userIdentifier": CommonProperties.userInfo?.idNo ?? ""
            //"001c44b8-2eee-415a-912d-601616e724be"
          },
          responseType: ResponseType.stream,
        ),
      );
      StreamTransformer<Uint8List, List<int>> unit8Transformer =
          StreamTransformer.fromHandlers(
        handleData: (data, sink) => sink.add(List<int>.from(data)),
      );

      StreamTransformer<String, String> stringTransformer =
          StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          print("sink : $data");
          sink.add(data);
        },
      );
      Stream stream = response.data?.stream
          .transform(unit8Transformer)
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .transform(stringTransformer);
      return stream;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<bool> sendFeedBack(
      {required String messID, required bool like}) async {
    Response? response;
    try {
      response = await webService.dio.post(ApiUrl.sendMessagechatBotFeedback,
          data: {"msg_id": messID, "feedback_value": like ? 1 : 0});
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      return result['msg_id'] == messID;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<List<SessionData>> getSessionHistory({required String id}) async {
    Response? response;
    try {
      response =
          await webService.dio.get("${ApiUrl.getChatgptOldSession}/${id}");

      var data = response.data["data"]?["result"];

      List<SessionData> parsedResult = data != null
          ? List<SessionData>.from(data.map((x) => SessionData.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<SessionData>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
      ;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<SessionDetails?> getSessionDetails({required String id}) async {
    Response? response;
    try {
      response =
          await webService.dio.get("${ApiUrl.getChatgptSessionDetails}/${id}");

      var data = response.data["data"]?["result"];

      SessionDetails? parsedResult =
          data != null ? SessionDetails.fromJson(data) : null;

      return parsedResult;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<ChatRefreshSession?> refreshSession({required String id}) async {
    Response? response;
    try {
      response = await webService.dio.get("${ApiUrl.refreshChatSession}/${id}");

      var data = response.data["data"];

      ChatRefreshSession? parsedResult =
          data != null ? ChatRefreshSession.fromJson(data) : null;

      return parsedResult;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<List<String>> getPromptQuestions({required String userId}) async {
    Response? response;
    try {
      response = await webService.dio.get("${ApiUrl.promptQuestions}/$userId");
      if (response.data["data"]['responseCode'] == "1") {
        List data = response.data["data"]['result'] as List ;
       var list = data.map((e) => e.toString()).toList();
        return list;
      }
      return [];
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }
}
