import 'package:flutter/widgets.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/friends_on_map/models/chat_message.dart';
import 'package:mapness/features/friends_on_map/providers/chat_presence.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'incoming_chat_notice.g.dart';

/// Consecutive messages from the same friend inside this window fold into one
/// notice ("Bob: 3 new messages") instead of stacking toasts.
const Duration kChatNoticeCoalesceWindow = Duration(seconds: 6);

/// Longest message preview shown in a notice.
const int kChatNoticePreviewMax = 120;

/// The in-app "new message" notice (S-21). `MapPage` listens and shows the
/// toast; this holds only what the toast needs.
class ChatNotice {
  /// Unique per emission, so a listener fires even for an otherwise identical
  /// follow-up.
  final int id;
  final String friendId;
  final String friendDisplayName;

  /// The text to show, or null for a place card.
  final String? preview;
  final bool isPlace;

  /// How many messages this notice stands for (coalescing).
  final int count;

  const ChatNotice({
    required this.id,
    required this.friendId,
    required this.friendDisplayName,
    required this.count,
    this.preview,
    this.isPlace = false,
  });
}

/// Pure rule for "should this incoming message pop a notice" — kept free of
/// providers/platform so every case is unit-testable.
///
/// - never for the user's own messages (another device of theirs) or deleted ones;
/// - never while the app isn't in the foreground (there is no system push — the
///   badge is what they see on return);
/// - never while the conversation with that friend is open (the message is
///   already in front of them) or the conversation list is open (it updates);
/// - never during active turn-by-turn navigation (don't distract a driver).
bool shouldNotifyIncomingMessage({
  required ChatMessage message,
  required String friendId,
  required bool appInForeground,
  required ChatPresenceState presence,
  required bool navigationActive,
}) {
  if (message.mine || message.deleted) {
    return false;
  }
  if (!appInForeground || navigationActive) {
    return false;
  }
  if (presence.conversationsOpen || presence.chatFriendId == friendId) {
    return false;
  }
  return true;
}

/// True while turn-by-turn navigation is on screen — same check the search
/// providers use (`currentSegments`), wrapped in a provider so tests can
/// override it.
@riverpod
bool chatNavigationActive(Ref ref) {
  try {
    return ref.read(appRouterProvider).currentSegments.any((s) => s.name == PathNavRoute.name);
  } on Object catch (_) {
    return false;
  }
}

@Riverpod(keepAlive: true)
class IncomingChatNotice extends _$IncomingChatNotice {
  int _nextId = 0;
  DateTime? _lastAt;

  @override
  ChatNotice? build() => null;

  /// Called by the events socket for every `message_created`. Decides, then —
  /// if it passes — emits (or folds into) a notice.
  void onIncoming({required String friendId, required String friendDisplayName, required ChatMessage message}) {
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    final show = shouldNotifyIncomingMessage(
      message: message,
      friendId: friendId,
      // Unknown (null, e.g. in tests) counts as foreground.
      appInForeground: lifecycle == null || lifecycle == AppLifecycleState.resumed,
      presence: ref.read(chatPresenceProvider),
      navigationActive: ref.read(chatNavigationActiveProvider),
    );
    if (!show) {
      return;
    }

    final now = DateTime.now();
    final previous = state;
    final lastAt = _lastAt;
    final fold =
        previous != null &&
        previous.friendId == friendId &&
        lastAt != null &&
        now.difference(lastAt) <= kChatNoticeCoalesceWindow;
    _lastAt = now;

    final body = message.body;
    state = ChatNotice(
      id: _nextId++,
      friendId: friendId,
      friendDisplayName: friendDisplayName,
      count: fold ? previous.count + 1 : 1,
      isPlace: message.kind == ChatMessageKind.placeCard,
      preview: body == null
          ? null
          : (body.length > kChatNoticePreviewMax ? '${body.substring(0, kChatNoticePreviewMax)}…' : body),
    );
  }
}
