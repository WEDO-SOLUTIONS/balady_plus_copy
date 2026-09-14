import 'dart:convert';

import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ProfileAccountService {
  ProfileAccountService({WebService? webService}) : _webService = webService ?? sl<WebService>();

  final WebService _webService;

  String get _deviceId => CommonProperties.deviceId ?? 'mobile-app';

  String get _languageCode => translator.activeLanguageCode;

  String get _token => CommonProperties.token;

  String _calculateVerifyingKey({
    required String url,
    required String method,
    Map<String, dynamic>? body,
  }) => hashRequest(
    url: url,
    method: method,
    body: body?.entries.map((e) => '${e.key}=${e.value}').join('&') ?? '',
    bearer: _token,
  );

  static String hashRequest({
    required String url,
    required String bearer,
    required String method,
    required String? body,
  }) {
    final String message = '$url${method}Bearer $bearer${body ?? ""}';
    final key = utf8.encode(RemoteConfig.hmCode);
    final bytes = utf8.encode(message);
    final hMacSha256 = Hmac(sha256, key);
    final digest = hMacSha256.convert(bytes);
    return base64Encode(digest.bytes);
  }

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
    final fullUrl = '${RemoteConfig.ssoUrl}$path';
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
    return _parseSessionId(response.data, response.headers);
  }

  /// SSO may return the session id as a string, nested object, or top-level field.
  String _parseSessionId(raw, Headers headers) {
    if (raw is String && raw.trim().isNotEmpty) {
      return raw.trim();
    }

    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      final data = map['data'];

      if (data is String && data.trim().isNotEmpty) {
        return data.trim();
      }
      if (data is Map) {
        final nested = _readSessionIdField(Map<String, dynamic>.from(data));
        if (nested != null) {
          return nested;
        }
      }

      final topLevel = _readSessionIdField(map);
      if (topLevel != null) {
        return topLevel;
      }
    }

    for (final key in const ['sessionid', 'sessionId', 'SessionId', 'x-session-id']) {
      final value = headers.value(key);
      if (value != null && value.trim().isNotEmpty) {
        return value.trim();
      }
    }

    if (kDebugMode) {
      debugPrint('SendVerificationEmail: could not parse sessionId from response: $raw');
    }
    throw StateError('SendVerificationEmail: missing sessionId in response');
  }

  String? _readSessionIdField(Map<String, dynamic> map) {
    for (final key in const ['sessionId', 'SessionId', 'session_id', 'id']) {
      final value = map[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }

  Future<bool> verifyEmail({
    required String sessionId,
    required String otp,
  }) async {
    const path = '/api/user/VerifyEmail';
    final fullUrl = '${RemoteConfig.ssoUrl}$path';
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

  Future<bool> updateUserProfile({
    required Map<String, dynamic> changes,
  }) async {
    if (changes.isEmpty) {
      return true;
    }

    const path = '/api/user/UpdateUserProfile';
    final fullUrl = '${RemoteConfig.ssoUrl}$path';
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
    final fullUrl = '${RemoteConfig.ssoUrl}$path';

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
