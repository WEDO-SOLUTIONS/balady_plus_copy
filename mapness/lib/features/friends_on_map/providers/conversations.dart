import 'package:mapness/features/friends_on_map/models/conversation.dart';
import 'package:mapness/features/friends_on_map/providers/chat_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversations.g.dart';

/// R-104/R-105: the conversation list and total unread count. Refetched on
/// the backend's `conversations_changed` event (see
/// `friends_on_map_events_socket.dart`).
@riverpod
Future<ConversationList> conversations(Ref ref) => ref.watch(chatRepositoryProvider).getConversations();
