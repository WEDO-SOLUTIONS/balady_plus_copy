import 'package:dio/dio.dart' show DioError;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../../core/errors/errors_exports.dart'
    show NoDataFoundException, ServerException;
import '../../../../../core/services/global/crm_web_service.dart';
import '../../../../../core/services/services_exports.dart' show WebService;
import '../../../../../core/utils/utils_exports.dart' show ApiUrl, Log;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show ResponseBodyModel;
import '../../requests_exports.dart'
    show
        MunicipalityModel,
        RequestsModel,
        RequestStatusModel,
        RequestSubTypeModel,
        RequestSubTypeParamsModel,
        RequestTypeModel,
        RequestsParamsModel,
        SubMunicipalityModel,
        SubMunicipalityParamsModel;

abstract class RequestsRemoteDataSource {}

class RequestsRemoteDataSourceImplementation
    implements RequestsRemoteDataSource {
  final WebService webService;
  final CRMWebService crmWebService;

  RequestsRemoteDataSourceImplementation(
      {required this.webService, required this.crmWebService});
}
