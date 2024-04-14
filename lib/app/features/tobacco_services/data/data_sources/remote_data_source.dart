import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/tobacco_services/data/models/disclosure_request.dart';
import 'package:balady_plus/app/features/tobacco_services/data/models/facility.dart';
import 'package:balady_plus/app/features/tobacco_services/data/models/tobacco_schedule.dart';
import 'package:dio/dio.dart' show DioError, FormData, MultipartFile, Options;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart' as http;

abstract class TobaccoListRemoteDataSource {
  Future<List<Facility>> getUserFacilities();

  Future<TobaccoSchedule> getUserFacilitiesDetails(String registrationNumber);

  Future uploadFile(FileDataItem file);

  Future uploadDisclosure(DisclosureRequest disclosureRequest);
}

class TobaccoListRemoteDataSourceImplementation
    implements TobaccoListRemoteDataSource {
  final WebService webService;

  TobaccoListRemoteDataSourceImplementation({required this.webService});

  @override
  Future<List<Facility>> getUserFacilities() async {
    var response;
    try {
      response = await webService.dio.get(
        ApiUrl.getUserFacilities,
      );
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      return List<Facility>.from(result.map((e) => Facility.fromJson(e)))
          .toList();
    } on DioError catch (error) {
      // "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      if (error.response != null &&
          error.response!.data["data"]['responseCode'] == 'TMAE002') {
        throw NoDataFoundException(
          error.response!.requestOptions,
          error.response!,
        );
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      // "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(errorMessage: ex.toString()),
          response: response,
        );
      }
    }
  }

  @override
  Future<TobaccoSchedule> getUserFacilitiesDetails(
    String registrationNumber,
  ) async {
    var response;
    try {
      response = await webService.dio.get(
        ApiUrl.getTobaccoDisclosure,
        queryParameters: {
          "registrationNumber": registrationNumber,
        },
      );
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      return TobaccoSchedule.fromJson(result);
    } on DioError catch (error) {
      // "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      // "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(errorMessage: ex.toString()),
          response: response,
        );
      }
    }
  }

  @override
  Future<String> uploadFile(FileDataItem file) async {
    var response;
    try {
      String contentTyp = lookupMimeType(file.filePath)!;
      final formData = FormData.fromMap(
        {
          "file": await MultipartFile.fromFile(
            file.filePath,
            filename: file.fileName,
            contentType: http.MediaType.parse(contentTyp),
          ),
        },
      );
      response = await webService.dio.post(
        ApiUrl.getTobaccoDisclosureUploadFile,
        data: formData,
        options: Options(
          headers: {
            "fileContentType": contentTyp,
          },
        ),
      );
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      return result['attachmentId'];
    } on DioError catch (error) {
      // "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      // "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(errorMessage: ex.toString()),
          response: response,
        );
      }
    }
  }

  @override
  Future uploadDisclosure(DisclosureRequest disclosureRequest) async {
    var response;
    try {
      response = await webService.dio.post(
        ApiUrl.getTobaccoDisclosureUpload,
        data: disclosureRequest.toJson(),
      );
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      return result;
    } on DioError catch (error) {
      // "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      // "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(errorMessage: ex.toString()),
          response: response,
        );
      }
    }
  }
}
