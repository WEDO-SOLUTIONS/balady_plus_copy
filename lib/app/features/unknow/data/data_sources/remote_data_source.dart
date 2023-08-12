import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:dio/dio.dart' show DioError, Options;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/global/crm_web_service.dart';
import '../../../../core/services/global/web_service.dart';
import '../../../../core/utils/constants/apis/api_info.dart';
import '../../../entry_point/presentation/cubit/auth_cubit.dart';
import '../../../profile_features/incidents/domain/entities/download_file_params.dart';
import '../../../transaction_inquiry/presentation/core/models/download_file_result.dart';

abstract class RequestsRemoteDataSource {
  Future<DownloadIMSFileResult?> downloadFile(
      {required DownLoadFileParams params});
}

class RequestsRemoteDataSourceImplementation
    implements RequestsRemoteDataSource {
  final WebService webService;
  final CRMWebService crmWebService;

  RequestsRemoteDataSourceImplementation(
      {required this.webService, required this.crmWebService});

  @override
  Future<DownloadIMSFileResult?> downloadFile(
      {required DownLoadFileParams params}) async {
    var response;

    try {
      Map<String, dynamic> queryParms = {};

      response = await webService.dio.get(ApiUrl.DOWNLOAD_FILE_URL,
          queryParameters: {"FileKey": params.fileKey},
          options: Options(headers: {
            'Authorization':
                'Bearer ${sl<EntryPointCubit>().state.apigeeToken?.accessToken}'
          }));

      print(response.data);
      final result = DownloadIMSFileResult.fromJson(response.data);

      return result;
    } on DioError catch (error) {
      print(error);
      var errorCode;

      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, errorCode: errorCode);
    } catch (ex) {
      print(ex);
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //  CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }
}
