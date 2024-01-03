import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:dio/dio.dart' show Options,ResponseType, Response ,DioError;
import 'package:localize_and_translate/localize_and_translate.dart';

abstract class ChatBotDataSources {
  Future<Stream> sendQuestionMessage({required String question});
}

class ChatBotDataSourcesImplementation extends ChatBotDataSources {
  final WebService webService;

  ChatBotDataSourcesImplementation({required this.webService});

  @override
  Future<Stream> sendQuestionMessage(
      {required String question}) async {
    Response? response;
    try {
      response = await webService.dio.get(
        // ApiUrl.chatBot,
        "https://realtime.ably.io/event-stream?channels=myChannel&v=1.2&key=xVLyHw.ZUmIRw:SwXPp7FC8_V5l3Y8NyG97zhQh1fd1Yma9ADKa-0NWos",
        // data: {"question": question},
        options: Options(
          headers: {"Accept": "*/*"},
          responseType: ResponseType.stream,
        ),
      );
      StreamTransformer<Uint8List, List<int>> unit8Transformer =
      StreamTransformer.fromHandlers(
        handleData: (data, sink) => sink.add(List<int>.from(data)),
      );
      Stream stream = response.data?.stream
          .transform(unit8Transformer)
          .transform(const Utf8Decoder())
          .transform(const LineSplitter());
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

  // Future<ChatBotMessageModel> sendQuestionMessageS(
  //     {required String question}) async {
  //   var response;
  //   try {
  //
  //   } on DioError catch (error) {
  //     if (error is NoDataFoundException) {
  //       rethrow;
  //     }
  //     throw ServerException(
  //       error.toString(),
  //       statusCode: error.response?.statusCode,
  //       dioError: error,
  //     );
  //   } catch (ex) {
  //     if (ex is ServerException) {
  //       rethrow;
  //     } else {
  //       throw ServerException(
  //         "errors_server_error_2".tr(),
  //         exception: APIException(
  //           errorMessage: ex.toString(),
  //         ),
  //         response: response,
  //       );
  //     }
  //   }
  // }
}
