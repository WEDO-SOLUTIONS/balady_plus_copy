import 'dart:convert' show base64Decode, base64Encode, utf8;

import 'package:crypto/crypto.dart';
String hashRequest_(
  String url,
  String method, {
  String? body,
  bool authorization = false,
  String? corelationId,
}) {
//var encodedURL = Uri.encodeComponent(url);

  String message = "";
  message = url + method;

  if (corelationId != null) message += corelationId;
  const token =
      "eyJhbGciOiJSUzI1NiIsImtpZCI6IjhFRDBCN0UzRjNDOTFBOEQwMUU3MEMxRUM4MTNGQTJBRjgxOEQ5MUZSUzI1NiIsIng1dCI6Imp0QzM0X1BKR28wQjV3d2V5QlA2S3ZnWTJSOCIsInR5cCI6ImF0K2p3dCJ9.eyJpc3MiOiJodHRwczovL3Nzb2FwcGRldi5tb21yYS5nb3Yuc2EiLCJuYmYiOjE2OTEzMTQxMTEsImlhdCI6MTY5MTMxNDExMSwiZXhwIjoxNjkyNTIzNzExLCJhdWQiOlsiRW1wbG95ZWVBZG1pbnN0cmF0aW9uLkFwaSIsImh0dHBzOi8vc3NvYXBwZGV2Lm1vbXJhLmdvdi5zYS9yZXNvdXJjZXMiXSwic2NvcGUiOlsib3BlbmlkIiwicHJvZmlsZSIsIkVtcGxveWVlQWRtaW5zdHJhdGlvbi5BcGkiLCJvZmZsaW5lX2FjY2VzcyJdLCJhbXIiOlsicHdkIl0sImNsaWVudF9pZCI6ImJhbGFkeV9tb2JpbGVfYXBwIiwic3ViIjoiN2MzNjY3NzgtYTAyMS00NzA3LTgyNDMtN2MzZGY1OWM3ZmY4IiwiYXV0aF90aW1lIjoxNjkxMzE0MTEwLCJpZHAiOiJsb2NhbCIsImVtYWlsIjoibS5haG1lZEBpbm5vc29mdC5tZXh4IiwicGhvbmVfbnVtYmVyIjoiNTkyODQyMjc1IiwibmFtZSI6IjIxMTE2OTI1OTIiLCJtYWlsIjoibS5haG1lZEBpbm5vc29mdC5tZXh4Iiwic2V4IjoiMSIsImRvYiI6IjMxLzA1LzE5OTUiLCJwaG9uZSI6IjA1OTI4NDIyNzUiLCJhcl9uYW1lIjoi2YXYrdmF2YjYryDZhdit2YXYr9io2YfYp9ih2KfZhNiv2YrZhiAg2KfYrdmF2K8iLCJlbl9uYW1lIjoiTUFITU9VRCBNT0hBTUVEQkFIQUVMREkgIEFITUVEIiwiaWRfbm8iOiIyMTExNjkyNTkyIiwibmlkIjoiMjA3IiwibmF0aW9uYWxpdHkiOiLZhdi12LEiLCJpZF90eXBlIjoiMiIsInNuYW1lIjoi2YXYrdmF2YjYryzZhdit2YXYr9io2YfYp9ih2KfZhNiv2YrZhiws2KfYrdmF2K8iLCJzaWQiOiI2REM4OEI1MDQ4NTRFNjE0Q0FFQUVENjJFODM4QTczRSIsImp0aSI6IjMxMDM4MjkxNEI1NzVDOUNFMzE5OUFBQUM1RjIwRjlFIn0.nQsrmyFoDuI9Qj1eRfAUAuqDIgvKIyZWRFanZChXQV0f-YZuMOlnYGRffegL0BhTSM2sRup57OicRhBQsEtAZHxaDmvjYp4cF0JSFTnIz5DWW5ZnCaoCVL-Jzzyyy5GC55oLiXrgrlWS_O0Y2SA-mkdzgGz-nTBjdiqYoY6BO7SWUiZb8RJLf7KJZEWALsqspEo1F836dvnCOPmKBT8Vr3iDxD5cbEL-u2R9Xt4VMXAO9B7ziXcW21kd6Si6mNPOSe29ga0HE4E5gRNMBUWQ3nLHfKrmNI0OYMdGGhclzEu8p1qaKJAIOPBbF6tuBXova0DpdjwZloM5ebSLF1FTBA";

  // if (authorization) message += 'Bearer ${CommonProperties.token}';
  if (authorization) message += 'Bearer $token';

  if (body != null) {
    message += body.replaceAll(RegExp(r'^/\\n/g'), "");
  }
/*message.errorLog();
    ;
    body.errorLog();*/

  message.trim();
  const hmCode =
      "oxqUHJH1KXD84vP0KYBnyaHDUk5sJ9HkzqPDTice5TABqvfACZaLscG1TjjyPgIT";
// devVal: "oxqUHJH1KXD84vP0KYBnyaHDUk5sJ9HkzqPDTice5TABqvfACZaLscG1TjjyPgIT",
// stgVal: "oxqUHJH1KXD84vP0KYBnyaHDUk5sJ9HkzqPDTice5TABqvfACZaLscG1TjjyPgIT",
// preVal: "oxqUHJH1KXD84vP0KYBnyaHDUk5sJ9HkzqPDTice5TABqvfACZaLscG1TjjyPgIT",
// prodVal: "TU9NUkEgTW9iaWxlIFRlYW0gMjAyMg==",
//   var key = utf8.encode(RemoteConfig.hmCode);
  var key = utf8.encode(hmCode);
  var bytes = utf8.encode(message);

  var hmacSha256 = Hmac(sha256, key);
  var digest = hmacSha256.convert(bytes);
  String base64 = base64Encode(digest.bytes);
  return base64;
}
