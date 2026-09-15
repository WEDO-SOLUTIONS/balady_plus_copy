import 'dart:io';

import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../model/cv_upload_response.dart';
import '../model/profile_model/profile_model.dart';
import '../model/volunteer_lookup.dart';

abstract class VolunteerProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<List<VolunteerLookup>> getRegions();
  Future<List<VolunteerLookup>> getCities(String regionId);
  Future<List<VolunteerLookup>> getSpecializations();
  Future<List<VolunteerLookup>> getQualifications();
  Future<List<VolunteerLookup>> getLaunguages();
  Future<List<VolunteerLookup>> getFields();
  Future<List<VolunteerLookup>> getBloodTypes();
  Future<List<VolunteerLookup>> getDiseases();
  Future<List<VolunteerLookup>> getSkills();
  Future<List<VolunteerLookup>> getLvls();
  Future<List<VolunteerLookup>> getInterests();
  Future<List<VolunteerLookup>> getVolunteeringFields();
  Future<List<VolunteerLookup>> getVolunteeringServices(String parentId);
  Future<CVUploadResponse> uploadCV(FileDataItem file);
  Future<void> submitProfile(
      Map<String, dynamic> profileData, String profileId);
}

class VolunteerDataSourceImpl extends VolunteerProfileRemoteDataSource {
  final WebService webService;
  VolunteerDataSourceImpl({required this.webService});

  @override
  Future<ProfileModel> getProfile() async {
    Response? response;
    try {
      response = await webService.dio.get(ApiUrl.getVolunteerProfile);
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      return ProfileModel.fromJson(result);
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      // "DioError $error".errorLog();
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
          'errors_server_error_2'.tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<List<VolunteerLookup>> getRegions() async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.getRegions,
      );

      final data = response.data;
      final List result = ResponseBodyModel.fromMap(data).data?.result;
      return result
          .map<VolunteerLookup>(
              (e) => VolunteerLookup.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
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
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException('errors_server_error_2'.tr());
      }
    }
  }

  @override
  Future<List<VolunteerLookup>> getCities(String regionId) async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.getcities,
        queryParameters: {'parentId': regionId},
      );

      final data = response.data;
      final List result = ResponseBodyModel.fromMap(data).data?.result;
      return result
          .map<VolunteerLookup>(
              (e) => VolunteerLookup.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
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
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException('errors_server_error_2'.tr());
      }
    }
  }

  @override
  Future<List<VolunteerLookup>> getSpecializations() async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.getSpecializations,
      );

      final data = response.data;
      final List result = ResponseBodyModel.fromMap(data).data?.result;
      return result
          .map<VolunteerLookup>(
              (e) => VolunteerLookup.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
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
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException('errors_server_error_2'.tr());
      }
    }
  }

  @override
  Future<List<VolunteerLookup>> getQualifications() async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.getQualifications,
      );

      final data = response.data;
      final List result = ResponseBodyModel.fromMap(data).data?.result;
      return result
          .map<VolunteerLookup>(
              (e) => VolunteerLookup.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
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
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException('errors_server_error_2'.tr());
      }
    }
  }

  @override
  Future<List<VolunteerLookup>> getLaunguages() async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.getLaunguages,
      );

      final data = response.data;
      final List result = ResponseBodyModel.fromMap(data).data?.result;
      return result
          .map<VolunteerLookup>(
              (e) => VolunteerLookup.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
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
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException('errors_server_error_2'.tr());
      }
    }
  }

  @override
  Future<List<VolunteerLookup>> getFields() async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.getFields,
      );

      final data = response.data;
      final List result = ResponseBodyModel.fromMap(data).data?.result;
      return result
          .map<VolunteerLookup>(
              (e) => VolunteerLookup.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
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
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException('errors_server_error_2'.tr());
      }
    }
  }

  @override
  Future<List<VolunteerLookup>> getBloodTypes() async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.getBloodTypes,
      );

      final data = response.data;
      final List result = ResponseBodyModel.fromMap(data).data?.result;
      return result
          .map<VolunteerLookup>(
              (e) => VolunteerLookup.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
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
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException('errors_server_error_2'.tr());
      }
    }
  }

  @override
  Future<List<VolunteerLookup>> getDiseases() async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.getDiseases,
      );

      final data = response.data;
      final List result = ResponseBodyModel.fromMap(data).data?.result;
      return result
          .map<VolunteerLookup>(
              (e) => VolunteerLookup.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
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
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException('errors_server_error_2'.tr());
      }
    }
  }

  @override
  Future<List<VolunteerLookup>> getInterests() async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.getInterests,
      );

      final data = response.data;
      final List result = ResponseBodyModel.fromMap(data).data?.result;
      return result
          .map<VolunteerLookup>(
              (e) => VolunteerLookup.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
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
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException('errors_server_error_2'.tr());
      }
    }
  }

  @override
  Future<List<VolunteerLookup>> getLvls() async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.getLvls,
      );

      final data = response.data;
      final List result = ResponseBodyModel.fromMap(data).data?.result;
      return result
          .map<VolunteerLookup>(
              (e) => VolunteerLookup.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
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
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException('errors_server_error_2'.tr());
      }
    }
  }

  @override
  Future<List<VolunteerLookup>> getSkills() async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.getSkills,
      );

      final data = response.data;
      final List result = ResponseBodyModel.fromMap(data).data?.result;
      return result
          .map<VolunteerLookup>(
              (e) => VolunteerLookup.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
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
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException('errors_server_error_2'.tr());
      }
    }
  }

  @override
  Future<List<VolunteerLookup>> getVolunteeringFields() async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.getVolunteeringFields,
      );

      final data = response.data;
      final List result = ResponseBodyModel.fromMap(data).data?.result;
      return result
          .map<VolunteerLookup>(
              (e) => VolunteerLookup.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
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
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException('errors_server_error_2'.tr());
      }
    }
  }

  @override
  Future<List<VolunteerLookup>> getVolunteeringServices(String parentId) async {
    Response response;

    try {
      response = await webService.dio.get(ApiUrl.getVolunteeringServices, queryParameters: {'parentId': parentId});

      final data = response.data;
      final List result = ResponseBodyModel.fromMap(data).data?.result;
      return result.map<VolunteerLookup>((e) => VolunteerLookup.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(), statusCode: error.response?.statusCode, dioError: error);
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
        throw ServerException('errors_server_error_2'.tr());
      }
    }
  }

  @override
  Future<CVUploadResponse> uploadCV(FileDataItem file) async {
    Response? response;
    try {
      // Read file bytes
      final fileBytes = await File(file.filePath).readAsBytes();
      int timeStamp = DateTime.now().millisecondsSinceEpoch;
      String newFileName = file.fileName
          .replaceRange(0, file.fileName.indexOf("."), "$timeStamp");

      response = await webService.dio.post(
        ApiUrl.uploadVolunteerCV,
        data: fileBytes,
        options: Options(
          headers: {
            'contentDisposition': 'file; filename="$newFileName"',
            'Content-Type': 'application/octet-stream',
          },
          contentType: 'application/octet-stream',
        ),
      );

      final data = response.data;
      final responseBody = ResponseBodyModel.fromMap(data);
      final result = responseBody.data?.result;

      if (responseBody.data?.responseCode == '1') {
        return CVUploadResponse.fromJson(result as Map<String, dynamic>);
      } else {
        throw ServerException(
          responseBody.data?.responseMessage ?? 'Upload failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
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
          'errors_server_error_2'.tr(),
          exception: APIException(errorMessage: error.toString()),
          response: response,
        );
      }
    }
  }

  @override
  Future<void> submitProfile(
      Map<String, dynamic> profileData, String profileId) async {
    Response? response;
    try {
      response = await webService.dio.put(
        ApiUrl.submitVolunteerProfile(profileId),
        data: profileData,
      );

      final data = response.data;
      final responseBody = ResponseBodyModel.fromMap(data);

      if (responseBody.data?.responseCode != '1') {
        throw ServerException(
          responseBody.data?.responseMessage ?? 'Profile submission failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
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
          'errors_server_error_2'.tr(),
          exception: APIException(errorMessage: error.toString()),
          response: response,
        );
      }
    }
  }
}
