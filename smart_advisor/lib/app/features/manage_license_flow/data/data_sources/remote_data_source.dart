import 'package:smart_advisor/app/core/dependency_injection/injection_container.dart';
import 'package:smart_advisor/app/core/utils/extensions/json_conversion.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';
import 'package:smart_advisor/app/features/manage_license_flow/domain/entities/commercial_license_model.dart';

import '../../domain/entities/license_request_params.dart';
import '../model/delegators_model.dart';
import '../model/license_details_model.dart';
import '../model/license_model.dart';
import '/app/core/utils/constants/apis/apis_get.dart';
import '/app/features/select_activity/data/models/permits_response_model.dart';
import 'package:dio/dio.dart' show DioException, Options;
import '/app/core/utils/constants/language.dart';

import '../../../../core/errors/errors_exports.dart' show ServerException;
import '../../../../core/services/services_exports.dart'
    show SmartAdvisorWebService;
import '../../../_shared_feature_/presentation/models/response_body_model.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';

abstract class ManageLicenseDataSource {
  Future<List<DelegatorModel>> getDelegators();
  Future<List<LicensesResponseItem>> getLicenses(LicenseRequestParams request);
  Future<LicenseDetails> getLicenseDetails(String licenseNo);

  Future<String> issueCommercialLicense(
      CommercialLicenseModel commercialLicense);

  Future<String> renewCommercialLicense(int id);

  Future<String> cancelCommercialLicense(int id);

  Future<String> modifyCommercialLicense(
      int id, CommercialLicenseModel commercialLicense);

  Future<String> transferOwnershipCommercialLicense(
      int id, CommercialLicenseModel commercialLicense);
}

class ManageLicenseDataSourceImplementation implements ManageLicenseDataSource {
  final SmartAdvisorWebService webService;

  ManageLicenseDataSourceImplementation({required this.webService});

  @override
  Future<List<DelegatorModel>> getDelegators() async {
    try {
      final response = await webService.dio.get(
        ApiUrls.delegators,
      );

      print("=== Response getDelegators === \n${response.data}");

      final result = ResponseBodyModel.fromMap(response.data).data?.result;

      return result
          .map<DelegatorModel>(
              (e) => DelegatorModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (error) {
      throw ServerException(error.toString());
    } catch (ex) {
      print("==== Error getDelegators method === $ex");
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errorsServerError".tr());
      }
    }
  }

  // Issue Commercial License
  @override
  Future<String> issueCommercialLicense(
      CommercialLicenseModel commercialLicense) async {
    try {
      final response =
          await webService.dio.post(ApiUrls.issueCommercialLicense, data: {
        "activities": {
          "accommodationTypeId":
              commercialLicense.activities?.accommodationTypeId,
          "addedActivities":
              commercialLicense.activities?.addedActivities?.map((e) {
            return {
              "detailedActivityId": e.activityId.toString(),
              "area": e.area.toString(),
            };
          }).toList(),
          "isAtmFeesPaid": commercialLicense.activities?.isAtmFeesPaid,
          "mainActivity": {
            "area": commercialLicense.activities?.mainActivity?.area,
            "detailedActivityId":
                commercialLicense.activities?.mainActivity?.detailedActivityId
          },
          "shopArea": commercialLicense.activities?.shopArea,
          "unitCount": commercialLicense.activities?.unitCount,
          "workerTypeId": commercialLicense.activities?.workerTypeId
        },
        "crNumber": commercialLicense.crNumber,
        "crType": commercialLicense.crType,
        "site": {
          "krokiUrl": commercialLicense.site?.krokiUrl,
          "landNumber": commercialLicense.site?.landNumber,
          "latitude": commercialLicense.site?.latitude,
          "longitude": commercialLicense.site?.longitude,
          "mapNumber": commercialLicense.site?.mapNumber
        }
      });
      print("=== Response issueCommercialLicense === \n${response.data}");

      final result =
          ResponseBodyModel.fromMap(response.data).data?.result["requestId"];

      return result.toString();
    } on DioException catch (error) {
      throw ServerException(error.toString());
    } catch (ex) {
      print("==== Error issueCommercialLicense method === $ex");
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errorsServerError".tr());
      }
    }
  }

  // Cancel Commercial License
  @override
  Future<String> cancelCommercialLicense(int id) async {
    try {
      final response = await webService.dio.post(
        ApiUrls.cancelCommercialLicense(id),
      );
      print("=== Response cancelCommercialLicense === \n${response.data}");

      final result =
          ResponseBodyModel.fromMap(response.data).data?.result["requestId"];

      return result.toString();
    } on DioException catch (error) {
      throw ServerException(error.toString());
    } catch (ex) {
      print("==== Error cancelCommercialLicense method === $ex");
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errorsServerError".tr());
      }
    }
  }

  // Modify Commercial License
  @override
  Future<String> modifyCommercialLicense(
      int id, CommercialLicenseModel commercialLicense) async {
    try {
      final response = await webService.dio
          .post(ApiUrls.modifyCommercialLicense(id), data: {});
      print("=== Response modifyCommercialLicense === \n${response.data}");

      final result =
          ResponseBodyModel.fromMap(response.data).data?.result["requestId"];

      return result.toString();
    } on DioException catch (error) {
      throw ServerException(error.toString());
    } catch (ex) {
      print("==== Error modifyCommercialLicense method === $ex");
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errorsServerError".tr());
      }
    }
  }

  // Transfer Ownership Commercial License
  @override
  Future<String> transferOwnershipCommercialLicense(
      int id, CommercialLicenseModel commercialLicense) async {
    try {
      final response = await webService.dio
          .post(ApiUrls.transferOwnershipCommercialLicense(id), data: {
        "crNumber": commercialLicense.crNumber,
        "selectedPermits": commercialLicense.permits ?? []
      });
      print(
          "=== Response transferOwnershipCommercialLicense === \n${response.data}");

      final result =
          ResponseBodyModel.fromMap(response.data).data?.result["requestId"];

      return result.toString();
    } on DioException catch (error) {
      throw ServerException(error.toString());
    } catch (ex) {
      print("==== Error transferOwnershipCommercialLicense method === $ex");
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errorsServerError".tr());
      }
    }
  }

  @override
  Future<List<LicensesResponseItem>> getLicenses(
      LicenseRequestParams request) async {
    try {
      final response = await webService.dio.get(
        ApiUrls.licenses(request.crNumber, request.crType, request.role,
            request.licenseType, BaladyServices.userId),
      );

      print("=== Response getLicenses === \n${response.data}");

      final result = ResponseBodyModel.fromMap(response.data).data?.result;

      List<LicensesResponseItem> r = result
          .map<LicensesResponseItem>(
              (e) => LicensesResponseItem.fromJson(e as Map<String, dynamic>))
          .toList();

      return r; /*.where((e) => e.licenseStatusId != 5).toList();*/
    } on DioException catch (error) {
      throw ServerException(error.toString());
    } catch (ex) {
      print("==== Error getDelegators method === $ex");
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errorsServerError".tr());
      }
    }
  }

  @override
  Future<LicenseDetails> getLicenseDetails(String licenseNo) async {
    try {
      final response =
          await webService.dio.get(ApiUrls.licenseDetails(licenseNo),
              options: Options(headers: {
                "verifyingKEY": CommonFunctions.hashRequest(
                    authorization: true,
                    sl<EnvType>().domain + ApiUrls.licenseDetails(licenseNo),
                    "GET",
                    loginIdentityId: BaladyServices.userId,
                    loginIdentityType:
                        BaladyServices.userId.startsWith("1") ? "1" : "2"),
                "loginIdentityId": BaladyServices.userId,
                "loginIdentityType":
                    BaladyServices.userId.startsWith("1") ? "1" : "2"
              }));

      print("=== Response getLicenses === \n${response.data}");

      final result = ResponseBodyModel.fromMap(response.data).data?.result;

      return LicenseDetails.fromJson(result);
    } on DioException catch (error) {
      throw ServerException(error.toString());
    } catch (ex) {
      print("==== Error getDelegators method === $ex");
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errorsServerError".tr());
      }
    }
  }

  @override
  Future<String> renewCommercialLicense(int id) async {
    try {
      final response =
          await webService.dio.post(ApiUrls.renewCommercialLicense(id));
      print("=== Response renew === \n${response.data}");
      final result =
          ResponseBodyModel.fromMap(response.data).data?.result["requestId"];

      return result.toString();
    } on DioException catch (error) {
      throw ServerException(error.toString());
    } catch (ex) {
      print("==== Error transferOwnershipCommercialLicense method === $ex");
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errorsServerError".tr());
      }
    }
  }
}
