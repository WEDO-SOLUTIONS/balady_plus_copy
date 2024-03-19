import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/chatbot/data/models/chat_bot_message_model.dart';
import 'package:dio/dio.dart' show Options, ResponseType, Response, DioError;
import 'package:localize_and_translate/localize_and_translate.dart';

abstract class ChatBotDataSources {
  Future<Stream> sendQuestionMessageSSE({required String question});

  Future<ChatBotMessageModel> sendQuestionMessage({required String question});

  Future<bool> chatBotIsEnabled();
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
            "sessionId": "001c44b8-2eee-415a-912d-601616e724be"
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
          // String sOne = data.substring(7);
          // String sOne = data.replaceAll("u","");
          String sOne = data.replaceAll("\"", "");
          // sOne = sOne.replaceAll("\\", "");
          // var s = utf8.encode(sOne);
          // var y = utf8.decode(sOne.codeUnits);
          // var t = utf8.decode(sOne.runes.toList());
          // String data = String.fromCharCodes(dataUint8List);

          if (sOne != "\\" &&
              sOne != "end" &&
              sOne != "start" &&
              sOne.isNotEmpty) {
            // var re = RegExp(r'u(?<codePoint>[0-9A-Fa-f\u0621-\u064A]{4})');
            // var matches = re.allMatches(sOne);
            // var matches = sOne.split("u");
            // var codePoints = [
            //   for (var match in matches)
            //     int.parse(match.namedGroup('codePoint')!, radix: 16),
            // ];
            // var codepoint = int.parse(sOne, radix: 16);
            // String unicodeString = String.fromCharCode(codepoint);
            // print(unicodeString);
            // sink.add(String.fromCharCodes(codePoints));
            sink.add(sOne);
          }
          sink.add("");
        },
      );
      Stream stream = response.data?.stream
          .transform(unit8Transformer)
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .transform(stringTransformer);
      return stream;
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
