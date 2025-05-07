import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/super_app_js_bridge/model/access_token_model.dart';
import 'package:balady_plus/super_app_js_bridge/model/base_response.dart';
import 'package:balady_plus/super_app_js_bridge/model/user_profile_model.dart';
import 'package:dsbridge_flutter/dsbridge_flutter.dart';

class JsBridgeListener extends JavaScriptNamespaceInterface {
  @override
  void register() {
    registerFunction(getAccessToken);
    registerFunction(getUserProfile);
  }

  @pragma('vm:entry-point')
  void getAccessToken(dynamic msg, CompletionHandler handler) {
    if (CommonProperties.isLoggedIn) {
      BaseResponse response = BaseResponse(
        code: 200,
        message: "success",
        data: AccessTokenModel(
          accessToken: CommonProperties.token,
        ),
      );
      handler.complete(response.jsonEncodeModel());
    } else {
      BaseResponse response = BaseResponse(
        code: 401,
        message: "Unauthorized",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void getUserProfile(dynamic msg, CompletionHandler handler) {
    if (CommonProperties.isLoggedIn) {
      BaseResponse response = BaseResponse(
        code: 200,
        message: "success",
        data: UserProfileModel.fromJson(CommonProperties.userInfo!.toJson()),
      );
      handler.complete(response.jsonEncodeModel());
    } else {
      BaseResponse response = BaseResponse(
        code: 401,
        message: "Unauthorized",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }
}
