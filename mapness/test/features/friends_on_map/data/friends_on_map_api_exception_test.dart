import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_api_exception.dart';

DioException _dioError({
  int? statusCode,
  Map<String, dynamic>? data,
  Map<String, List<String>>? headers,
  DioExceptionType type = DioExceptionType.badResponse,
  String? message,
}) {
  final requestOptions = RequestOptions(path: '/v1/test');
  return DioException(
    requestOptions: requestOptions,
    type: type,
    message: message,
    response: statusCode == null
        ? null
        : Response<Map<String, dynamic>>(
            requestOptions: requestOptions,
            statusCode: statusCode,
            data: data,
            headers: Headers.fromMap(headers ?? const {}),
          ),
  );
}

void main() {
  group('mapFriendsOnMapError — known limit codes', () {
    test('friend_limit_reached (409, self)', () {
      final e = mapFriendsOnMapError(
        _dioError(
          statusCode: 409,
          data: {'error': 'friend limit reached', 'code': 'friend_limit_reached', 'subject': 'self', 'limit': 200},
        ),
      );
      expect(e.isLimit, isTrue);
      expect(e.limitCode, FriendsOnMapLimitCode.friendLimitReached);
      expect(e.subject, FriendsOnMapLimitSubject.self);
      expect(e.limit, 200);
      expect(e.retryAfter, isNull);
    });

    test('friend_limit_reached (409, peer)', () {
      final e = mapFriendsOnMapError(
        _dioError(
          statusCode: 409,
          data: {'error': 'peer at limit', 'code': 'friend_limit_reached', 'subject': 'peer'},
        ),
      );
      expect(e.limitCode, FriendsOnMapLimitCode.friendLimitReached);
      expect(e.subject, FriendsOnMapLimitSubject.peer);
    });

    test('pending_request_limit_reached (409)', () {
      final e = mapFriendsOnMapError(
        _dioError(
          statusCode: 409,
          data: {'error': 'too many pending', 'code': 'pending_request_limit_reached', 'limit': 50},
        ),
      );
      expect(e.limitCode, FriendsOnMapLimitCode.pendingRequestLimitReached);
      expect(e.limit, 50);
      expect(e.retryAfter, isNull);
    });

    test('request_creation_limit_reached (429) reads retryAfterSeconds from body', () {
      final e = mapFriendsOnMapError(
        _dioError(
          statusCode: 429,
          data: {
            'error': 'too many requests today',
            'code': 'request_creation_limit_reached',
            'limit': 20,
            'retryAfterSeconds': 3600,
          },
        ),
      );
      expect(e.limitCode, FriendsOnMapLimitCode.requestCreationLimitReached);
      expect(e.limit, 20);
      expect(e.retryAfter, const Duration(seconds: 3600));
    });

    test('invite_reset_limit_reached (429)', () {
      final e = mapFriendsOnMapError(
        _dioError(
          statusCode: 429,
          data: {
            'error': 'too many resets',
            'code': 'invite_reset_limit_reached',
            'limit': 10,
            'retryAfterSeconds': 7200,
          },
        ),
      );
      expect(e.limitCode, FriendsOnMapLimitCode.inviteResetLimitReached);
      expect(e.retryAfter, const Duration(seconds: 7200));
    });

    test('invite_resolution_rate_limited (429), retryAfterSeconds absent falls back to Retry-After header', () {
      final e = mapFriendsOnMapError(
        _dioError(
          statusCode: 429,
          data: {'error': 'too many attempts', 'code': 'invite_resolution_rate_limited'},
          headers: {
            'retry-after': ['120'],
          },
        ),
      );
      expect(e.limitCode, FriendsOnMapLimitCode.inviteResolutionRateLimited);
      expect(e.retryAfter, const Duration(seconds: 120));
    });
  });

  group('mapFriendsOnMapError — graceful degradation', () {
    test('409 with no code field is not guessed as a limit', () {
      final e = mapFriendsOnMapError(_dioError(statusCode: 409, data: {'error': 'some other conflict'}));
      expect(e.isLimit, isFalse);
      expect(e.limitCode, isNull);
      expect(e.message, 'some other conflict');
    });

    test('429 with an unrecognized code string is not guessed as a limit', () {
      final e = mapFriendsOnMapError(
        _dioError(statusCode: 429, data: {'error': 'rate limited', 'code': 'something_new_the_client_predates'}),
      );
      expect(e.isLimit, isFalse);
    });

    test('plain network error with no response', () {
      final e = mapFriendsOnMapError(
        _dioError(type: DioExceptionType.connectionError, message: 'Connection failed'),
      );
      expect(e.isLimit, isFalse);
      expect(e.statusCode, isNull);
      expect(e.message, 'Connection failed');
    });

    test('unrelated 404 falls back to the response error message', () {
      final e = mapFriendsOnMapError(_dioError(statusCode: 404, data: {'error': 'not found'}));
      expect(e.isLimit, isFalse);
      expect(e.statusCode, 404);
      expect(e.message, 'not found');
    });

    test('unrelated 500 with no body falls back to the DioException message', () {
      final e = mapFriendsOnMapError(_dioError(statusCode: 500, message: 'Internal Server Error'));
      expect(e.isLimit, isFalse);
      expect(e.statusCode, 500);
      expect(e.message, 'Internal Server Error');
    });
  });
}
