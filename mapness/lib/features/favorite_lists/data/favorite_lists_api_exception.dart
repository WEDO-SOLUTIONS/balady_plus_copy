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
    final error = data is Map<String, dynamic> ? data['error'] : null;
    if (error is Map<String, dynamic> && error['message'] is String) {
      return FavoriteListsApiException(
        code: error['code'] as String? ?? 'UNKNOWN_ERROR',
        message: error['message'] as String,
        messageAr: error['messageAr'] as String? ?? error['message'] as String,
        requestId: error['requestId'] as String?,
      );
    }
    return const FavoriteListsApiException(
      code: 'UNKNOWN_ERROR',
      message: 'Something went wrong. Please try again.',
      messageAr: 'حدث خطأ ما. يرجى المحاولة مرة أخرى.',
    );
  }

  final String code;
  final String message;
  final String messageAr;
  final String? requestId;

  /// Picks [message] or [messageAr] depending on [language]; defaults to English.
  String localizedMessage(Language language) => language == Language.arabic ? messageAr : message;

  @override
  String toString() => 'FavoriteListsApiException(code: $code, message: $message, requestId: $requestId)';
}
