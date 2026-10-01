import 'package:mapness/features/friends_on_map/models/chat_message.dart';
import 'package:mapness/features/friends_on_map/providers/chat_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_thread.g.dart';

/// The server-side messages of one thread, oldest first, plus the cursor for
/// loading older ones. Outbox messages are NOT in here — the UI merges them
/// in (see `ui/chat_page.dart`).
class ChatThreadState {
  final List<ChatMessage> items;
  final int? nextBefore;

  const ChatThreadState({required this.items, this.nextBefore});
}

/// One conversation's thread (R-101: the same history for both parties).
/// Auto-dispose: only meaningful while the chat is open; the outbox writes
/// into it via [upsert] only when it's alive (`ref.exists`).
@riverpod
class ChatThread extends _$ChatThread {
  @override
  Future<ChatThreadState> build(String friendId) async {
    final page = await ref.watch(chatRepositoryProvider).getThread(friendId);
    return ChatThreadState(items: page.items, nextBefore: page.nextBefore);
  }

  /// Loads the next older page, if any.
  Future<void> loadOlder() async {
    final current = state.value;
    final cursor = current?.nextBefore;
    if (current == null || cursor == null) {
      return;
    }
    final page = await ref.read(chatRepositoryProvider).getThread(friendId, before: cursor);
    if (!ref.mounted) {
      return;
    }
    final latest = state.value ?? current;
    state = AsyncData(ChatThreadState(items: [...page.items, ...latest.items], nextBefore: page.nextBefore));
  }

  /// Inserts or replaces one message, keeping the thread in `seq` order. Used
  /// for a just-sent message coming back from the server and for messages
  /// pushed over the socket, so neither flickers nor needs a refetch.
  void upsert(ChatMessage message) {
    final current = state.value;
    if (current == null) {
      return;
    }
    final items = [...current.items];
    final index = items.indexWhere((m) => m.id == message.id);
    if (index >= 0) {
      items[index] = message;
    } else {
      final seq = message.seq;
      // Events can arrive out of order relative to a refetch: insert before
      // the first message with a higher seq instead of blindly appending.
      final insertAt = seq == null ? -1 : items.indexWhere((m) => (m.seq ?? 0) > seq);
      if (insertAt >= 0) {
        items.insert(insertAt, message);
      } else {
        items.add(message);
      }
    }
    state = AsyncData(ChatThreadState(items: items, nextBefore: current.nextBefore));
  }
}
