import 'package:dio/dio.dart' show DioError;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../../core/errors/errors_exports.dart' show ServerException;
import '../../../../../core/services/services_exports.dart' show WebService;
import '../../../../../core/utils/utils_exports.dart' show ApiPOST, WithDelay;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show AuthDataModel;
import '../../sign_in_exports.dart' show SignInParamsModel;

abstract class SignInRemoteDataSource {
  Future<AuthDataModel> byPhoneNumber(SignInParamsModel params);
  Future<AuthDataModel> byUsernameAndPassword(SignInParamsModel params);
}

class SignInRemoteDataSourceImplementation implements SignInRemoteDataSource {
  final WebService webService;

  SignInRemoteDataSourceImplementation({required this.webService});

  @override
  Future<AuthDataModel> byPhoneNumber(SignInParamsModel params) async {
    try {
      if (params.phoneNumber == null || params.phoneNumber!.isEmpty) {
        throw const ServerException("Please add phone-number");
      }

      final response = await webService.dio.post(
        ApiPOST.login.url,
        queryParameters: params.toMap,
      );
      final decodedResponse = AuthDataModel.fromJson(response.data);
      return decodedResponse.toFuture();
    } on DioError catch (error) {
      throw ServerException(error.toString());
    } catch (ex) {
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<AuthDataModel> byUsernameAndPassword(SignInParamsModel params) async {
    try {
      if (params.username == null || params.username!.isEmpty) {
        throw const ServerException("Please add username");
      } else if (params.password == null || params.password!.isEmpty) {
        throw const ServerException("Please add password");
      }
      // final response = await webService.dio.post(
      //   ApiUrl.signIn,
      //   queryParameters: {
      //     ApiParams.username: username,
      //     ApiParams.password: password,
      //   },
      // );
      // final decodedResponse = AuthDataModel.fromJson(response.data);
      // return decodedResponse.toFuture();
      await Future.delayed(const Duration(seconds: 2));
      // throw ServerException("error.toString()");
      final decodedResponse = AuthDataModel.fromMap(
        const {"accessToken": "XXXXXXXXXXXXXXXXXXXXXX"},
      );
      return decodedResponse.toFuture();
    } on DioError catch (error) {
      throw ServerException(error.toString());
    } catch (ex) {
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }
}
