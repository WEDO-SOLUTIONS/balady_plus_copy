import 'dart:convert' show base64Decode, base64Encode, utf8;

import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:crypto/crypto.dart';

String hashRequest(
  String url,
  String method, {
  String? body,
  bool authorization = false,
  String? corelationId,
}) {
  String message = "";
  message = url + method;

  if (corelationId != null) message += corelationId;
  if (authorization) message += 'Bearer ${CommonProperties.token}';

  if (body != null) {
    message += body.replaceAll(RegExp(r'^/\\n/g'), "");
  }
  message.trim();
  var key = utf8.encode(RemoteConfig.hmCode);
  var bytes = utf8.encode(message);
  var hmacSha256 = Hmac(sha256, key);
  var digest = hmacSha256.convert(bytes);
  String base64 = base64Encode(digest.bytes);
  return base64;
}
