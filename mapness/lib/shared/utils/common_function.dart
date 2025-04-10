import 'dart:convert' show base64Encode, utf8;

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
  var message = '';
  message = url + method;

  if (corelationId != null) {
    message += corelationId;
  }
  if (authorization) {
    message += 'Bearer ${CommonProperties.token}';
  }

  if (body != null) {
    message += body.replaceAll(RegExp(r'^/\\n/g'), '');
  }
  message.trim();
  final key = utf8.encode(RemoteConfig.hmCode);
  final bytes = utf8.encode(message);
  final hmacSha256 = Hmac(sha256, key);
  final digest = hmacSha256.convert(bytes);
  final base64 = base64Encode(digest.bytes);
  return base64;
}

String? breakMarkerLabel(String? text, {int maxCharsPerLine = 40}) {
  if (text == null || text.trim().isEmpty) {
    return null;
  }

  final words = text.trim().split(RegExp(r'\s+'));
  final buffer = StringBuffer();
  int charCount = 0;

  for (int i = 0; i < words.length; i++) {
    final word = words[i];

    if (charCount + word.length > maxCharsPerLine) {
      if (charCount > 0) {
        buffer.write('\n');
      }
      buffer.write(word);
      charCount = word.length;
    } else {
      if (charCount > 0) {
        buffer.write(' ');
        charCount++;
      }
      buffer.write(word);
      charCount += word.length;
    }
  }
  return buffer.toString();
}
