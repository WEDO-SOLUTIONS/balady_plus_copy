import 'package:balady_plus/app/core/utils/extensions/log.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/objectable_transactions/domain/entities/enquiry_objection_reply_params.dart';
import 'package:balady_plus/app/features/objectable_transactions/domain/entities/validate_objection_params.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' show DioError, Options;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;
import '../../../core/errors/exceptions.dart';

import '../../../core/services/global/web_service.dart';
import '../../../core/utils/constants/apis/api_info.dart';
import '../../_shared_feature_/data/models/response_body_model.dart';
import '../data/qa_model.dart';

import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class QuestionRemoteDataSource {

  Future<List<dynamic>?> getQuestionList(String Id);
}




class  QuestionRemoteDataSourceImplementation implements QuestionRemoteDataSource {
  final WebService webService;

  QuestionRemoteDataSourceImplementation({required this.webService});

  @override
  Future<List<dynamic>?> getQuestionList(String Id) async {
    var response;
    try {
      response = await webService.dio.get(
        "${ApiUrl.ServiceQuestionList}/$Id",
      );

      final data = response.data;


      final result = ResponseBodyModel.fromMap(data).data?.result;

      final res=  List.from(result.map((e)=>QAModel.fromJson(e)));



      //result?.map((v) => QAModel.fromJson(v)).toList();
      return res;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
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
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }


}
