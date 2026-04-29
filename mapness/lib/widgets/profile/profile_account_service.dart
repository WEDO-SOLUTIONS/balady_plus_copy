import 'dart:convert';
import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ProfileAccountService {
  ProfileAccountService({WebService? webService}) : _webService = webService ?? sl<WebService>();

  final WebService _webService;

  static const String _ssoBaseUrl = 'https://ssoappdev.momra.gov.sa';

  String get _deviceId => CommonProperties.deviceId ?? 'mobile-app';
  String get _languageCode => translator.activeLanguageCode;
  String get _token =>CommonProperties.token;

  String _calculateVerifyingKey({
    required String url,
    required String method,
    Map<String, dynamic>? body,
  }) => CommonFunctions.hashRequest(
      url,
      method,
      body: body != null ? json.encode(body) : null,
      authorization: _token.isNotEmpty,
    );

  Options _getOptions({
    required String url,
    required String method,
    Map<String, dynamic>? body,
  }) {
    final verifyingKEY = _calculateVerifyingKey(
      url: url,
      method: method,
      body: body,
    );

    return Options(
      contentType: Headers.formUrlEncodedContentType,
      headers: {
        'Accept-Language': _languageCode,
        'lang': _languageCode,
        'Authorization': 'Bearer $_token',
        'verifyingKEY': verifyingKEY,
        'x-channel-id': 'MOBILE',
      },
    );
  }

  Future<String> sendVerificationEmail(String email) async {
    const path = '/api/user/SendVerificationEmail';
    const fullUrl = '$_ssoBaseUrl$path';
    final body = {'email': email, 'deviceId': _deviceId};

    final response = await _webService.dio.post(
      fullUrl,
      data: body,
      options: _getOptions(
        url: fullUrl,
        method: 'POST',
        body: body,
      ),
    );
    final data = response.data as Map<String, dynamic>;
    return (data['data'] ?? '') as String;
  }

  Future<bool> verifyEmail({
    required String sessionId,
    required String otp,
  }) async {
    const path = '/api/user/VerifyEmail';
    const fullUrl = '$_ssoBaseUrl$path';
    final body = {
      'sessionId': sessionId,
      'deviceId': _deviceId,
      'otp': otp,
    };

    final response = await _webService.dio.post(
      fullUrl,
      data: body,
      options: _getOptions(
        url: fullUrl,
        method: 'POST',
        body: body,
      ),
    );
    final data = response.data as Map<String, dynamic>;
    return data['data'] == true;
  }

  Future<bool> resendEmailOtp(String sessionId) async {
    const path = '/api/ReSendOtp';
    const fullUrl = '$_ssoBaseUrl$path';
    final body = {
      'sessionId': sessionId,
      'deviceId': _deviceId,
      'reSendOtpType': 'MobileLoginEmailVerify',
    };

    final response = await _webService.dio.post(
      fullUrl,
      data: body,
      options: _getOptions(
        url: fullUrl,
        method: 'POST',
        body: body,
      ),
    );
    final data = response.data as Map<String, dynamic>;
    return data['data'] == true;
  }

  Future<bool> updateUserProfile({
    required Map<String, dynamic> changes,
  }) async {
    if (changes.isEmpty) {
      return true;
    }

    const path = '/api/user/UpdateUserProfile';
    const fullUrl = '$_ssoBaseUrl$path';
    final body = <String, dynamic>{...changes};

    final response = await _webService.dio.post(
      fullUrl,
      data: body,
      options: _getOptions(
        url: fullUrl,
        method: 'POST',
        body: body,
      ),
    );
    final data = response.data as Map<String, dynamic>;
    return data['data'] == true;
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    const path = '/api/user/userinfo';
    const fullUrl = '$_ssoBaseUrl$path';

    final response = await _webService.dio.get(
      fullUrl,
      options: _getOptions(
        url: fullUrl,
        method: 'GET',
      ),
    );
    final data = response.data as Map<String, dynamic>;
    if (data.containsKey('data') && data['data'] != null) {
      return data['data'] as Map<String, dynamic>;
    }
    return data;
  }
}
