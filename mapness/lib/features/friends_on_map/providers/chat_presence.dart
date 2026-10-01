import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_presence.g.dart';

/// Which chat screens the user currently has open — what decides whether a
/// new message deserves an in-app notice (`incoming_chat_notice.dart`) and
/// whether a notice's "Open" replaces the current chat or stacks a new one
/// (`ui/open_chat.dart`).
class ChatPresenceState {
  /// The friend whose conversation is open, if any.
  final String? chatFriendId;

  /// Whether the conversation list is open.
  final bool conversationsOpen;

  const ChatPresenceState({this.chatFriendId, this.conversationsOpen = false});
}

/// keepAlive: written by screens as they open/close, read by the socket
/// handler that decides about notices — it must outlive any single screen.
///
/// Screens must call these from a post-frame callback / microtask, never
/// directly from `initState`/`dispose` (Riverpod forbids provider writes
/// during the widget-tree build/unmount phase).
@Riverpod(keepAlive: true)
class ChatPresence extends _$ChatPresence {
  @override
  ChatPresenceState build() => const ChatPresenceState();

  void chatOpened(String friendId) =>
      state = ChatPresenceState(chatFriendId: friendId, conversationsOpen: state.conversationsOpen);

  /// Only clears when [friendId] is still the open one: when a chat is
  /// *replaced* by another, the old screen's dispose runs after the new one
  /// registered and must not wipe it.
  void chatClosed(String friendId) {
    if (state.chatFriendId == friendId) {
      state = ChatPresenceState(conversationsOpen: state.conversationsOpen);
    }
  }

  void conversationsOpened() => state = ChatPresenceState(chatFriendId: state.chatFriendId, conversationsOpen: true);

  void conversationsClosed() => state = ChatPresenceState(chatFriendId: state.chatFriendId);
}
