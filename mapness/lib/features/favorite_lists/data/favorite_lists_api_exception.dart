import 'package:dio/dio.dart';
import 'package:mapness/shared/providers/app_language.dart';

class FavoriteListsApiException implements Exception {
  const FavoriteListsApiException({
    required this.code,
    required this.message,
    required this.messageAr,
    this.requestId,
  });

  factory FavoriteListsApiException.fromDioException(DioException exception) {
    final data = exception.response?.data;
    return data is Map<String, dynamic> ? FavoriteListsApiException.fromErrorBody(data) : _unknown;
  }

  /// Parses a decoded response body of the shape `{success: false, error: {code, message, messageAr, requestId}}`.
  ///
  /// Used both when Dio raises a [DioException] for a non-2xx response, and when the backend instead
  /// returns HTTP 200 with `success: false` in the body (some endpoints signal business errors this way
  /// rather than via the HTTP status code).
  factory FavoriteListsApiException.fromErrorBody(Map<String, dynamic> body) {
    final error = body['error'];
    if (error is Map<String, dynamic> && error['message'] is String) {
      return FavoriteListsApiException(
        code: error['code'] as String? ?? 'UNKNOWN_ERROR',
        message: error['message'] as String,
        messageAr: error['messageAr'] as String? ?? error['message'] as String,
        requestId: error['requestId'] as String?,
      );
    }
    return _unknown;
  }

  static const _unknown = FavoriteListsApiException(
    code: 'UNKNOWN_ERROR',
    message: 'Something went wrong. Please try again.',
    messageAr: 'حدث خطأ ما. يرجى المحاولة مرة أخرى.',
  );

  static const Map<String, String> _titlesByCode = {
    // TODO(claude): localize string
    'DUPLICATE_LIST_NAME': 'List name already exists',
  };

  final String code;
  final String message;
  final String messageAr;
  final String? requestId;

  /// Picks [message] or [messageAr] depending on [language]; defaults to English.
  String localizedMessage(Language language) => language == Language.arabic ? messageAr : message;

  /// Title tailored to [code] if one is mapped; `null` when no specific title exists,
  /// so the caller can fall back to a generic one.
  String? get title => _titlesByCode[code];

  @override
  String toString() => 'FavoriteListsApiException(code: $code, message: $message, requestId: $requestId)';
}
