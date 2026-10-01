import 'package:dio/dio.dart';
import 'package:mapness/features/friends_on_map/data/chat_repository.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_api_exception.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_json.dart';
import 'package:mapness/features/friends_on_map/models/chat_message.dart';
import 'package:mapness/features/friends_on_map/models/conversation.dart';

/// Real backend implementation — see `~/dev/code/wedo/go/balady-friends-service`'s
/// `internal/api/handlers_chat.go`.
class RemoteChatRepository implements ChatRepository {
  RemoteChatRepository(this._dio);

  final Dio _dio;

  @override
  Future<ConversationList> getConversations() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/v1/conversations');
      return conversationListFromJson(response.data!);
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }

  @override
  Future<ChatThreadPage> getThread(String friendId, {int? before, int limit = 50}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/conversations/$friendId/messages',
        queryParameters: {'limit': limit, if (before != null) 'before': before},
      );
      return chatThreadPageFromJson(response.data!);
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }

  @override
  Future<ChatMessage> sendMessage({
    required String friendId,
    required String clientMessageId,
    required ChatMessageKind kind,
    required DateTime composedAt,
    String? body,
    ChatPlace? place,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/v1/conversations/$friendId/messages/$clientMessageId',
        data: {
          'kind': kind == ChatMessageKind.text ? 'text' : 'place_card',
          if (body != null) 'body': body,
          if (place != null) 'place': {'latitude': place.latitude, 'longitude': place.longitude, 'label': place.label},
          'composedAt': composedAt.toUtc().toIso8601String(),
        },
      );
      return chatMessageFromJson(response.data!);
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }

  @override
  Future<void> markRead(String friendId) => _post('/v1/conversations/$friendId/read');

  @override
  Future<void> deleteMessage(String messageId) async {
    try {
      await _dio.delete<void>('/v1/messages/$messageId');
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }

  @override
  Future<void> reportMessage(String messageId) => _post('/v1/messages/$messageId/report');

  @override
  Future<void> reportConversation(String friendId) => _post('/v1/conversations/$friendId/report');

  Future<void> _post(String path) async {
    try {
      await _dio.post<void>(path);
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }
}
