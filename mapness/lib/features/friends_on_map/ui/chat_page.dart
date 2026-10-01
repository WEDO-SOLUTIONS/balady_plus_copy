import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_api_exception.dart';
import 'package:mapness/features/friends_on_map/models/chat_message.dart';
import 'package:mapness/features/friends_on_map/providers/chat_controller.dart';
import 'package:mapness/features/friends_on_map/providers/chat_outbox.dart';
import 'package:mapness/features/friends_on_map/providers/chat_presence.dart';
import 'package:mapness/features/friends_on_map/providers/chat_thread.dart';
import 'package:mapness/features/friends_on_map/ui/friends_on_map_error_dialog.dart';
import 'package:mapness/features/friends_on_map/ui/open_chat_place_on_map.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/chat_input_bar.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/chat_message_bubble.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_confirm_sheet.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/meetup_place_picker_sheet.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// R-107: only offer "delete" inside this window. The server is the
/// authority (`LIMIT_MESSAGE_DELETE_WINDOW_MINUTES`) and answers with
/// `message_delete_window_expired` if the two ever disagree.
const Duration _kDeleteWindow = Duration(minutes: 60);

/// S-21: one-to-one conversation with a friend. Server messages come from
/// [chatThreadProvider]; messages not yet acknowledged (R-103) come from
/// [chatOutboxProvider] and are appended, so a message is in the thread the
/// instant it's sent, online or not.
@RoutePage()
class ChatPage extends ConsumerStatefulWidget {
  final String friendId;
  final String displayName;

  const ChatPage({@PathParam('friendId') required this.friendId, required this.displayName, super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

/// Distance (px) from the newest message beyond which the user counts as
/// "reading history": new messages then raise the "new" pill instead of
/// being assumed seen.
const double _kNearBottom = 120;

class _ChatPageState extends ConsumerState<ChatPage> with WidgetsBindingObserver {
  final ScrollController _scroll = ScrollController();
  late final ChatPresence _presence;
  bool _loadingOlder = false;
  bool _markingRead = false;
  int _newBelow = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scroll.addListener(_onScroll);
    // Tells the notice logic this conversation is in front of the user, so a
    // message from this friend doesn't pop a toast on top of it. Provider
    // writes aren't allowed while the tree builds, hence the post-frame hop.
    _presence = ref.read(chatPresenceProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _presence.chatOpened(widget.friendId);
      }
    });
    // R-102: "read" is set only because the user actually has this
    // conversation open — whenever the thread changes while it is.
    ref.listenManual(
      chatThreadProvider(widget.friendId),
      (previous, next) => _onThreadChanged(previous?.value, next.value),
      fireImmediately: true,
    );
    // R-103: opening a thread is one of the triggers that resumes the outbox.
    unawaited(ref.read(chatOutboxProvider.notifier).flush());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scroll.dispose();
    final presence = _presence;
    final friendId = widget.friendId;
    Future<void>.microtask(() => presence.chatClosed(friendId));
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Messages that arrived while the app was backgrounded on this screen
    // were deliberately not marked read (see _maybeMarkRead).
    if (state == AppLifecycleState.resumed) {
      _maybeMarkRead(ref.read(chatThreadProvider(widget.friendId)).value);
    }
  }

  void _onScroll() {
    final position = _scroll.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      unawaited(_loadOlder());
    }
    // Back at the newest message: nothing left below.
    if (_newBelow > 0 && position.pixels <= _kNearBottom) {
      setState(() => _newBelow = 0);
    }
  }

  /// Marks read (R-102) and, if the user is reading history, counts messages
  /// that arrived below instead of yanking the view.
  void _onThreadChanged(ChatThreadState? previous, ChatThreadState? next) {
    _maybeMarkRead(next);
    if (previous == null || next == null || !_scroll.hasClients || _scroll.position.pixels <= _kNearBottom) {
      return;
    }
    // New = a higher seq than anything seen before. Older pages prepended by
    // loadOlder have lower seqs and must not count.
    final newestSeen = previous.items.fold<int>(0, (max, m) => (m.seq ?? 0) > max ? (m.seq ?? 0) : max);
    final arrived = next.items.where((m) => !m.mine && !m.deleted && (m.seq ?? 0) > newestSeen).length;
    if (arrived > 0) {
      setState(() => _newBelow += arrived);
    }
  }

  void _scrollToBottom() {
    if (!_scroll.hasClients) {
      return;
    }
    unawaited(_scroll.animateTo(0, duration: const Duration(milliseconds: 250), curve: Curves.easeOut));
    if (_newBelow > 0) {
      setState(() => _newBelow = 0);
    }
  }

  Future<void> _loadOlder() async {
    if (_loadingOlder || ref.read(chatThreadProvider(widget.friendId)).value?.nextBefore == null) {
      return;
    }
    _loadingOlder = true;
    try {
      await ref.read(chatThreadProvider(widget.friendId).notifier).loadOlder();
    } on Object catch (e) {
      logger.log('friends_on_map: loading older messages failed: $e');
    } finally {
      _loadingOlder = false;
    }
  }

  void _maybeMarkRead(ChatThreadState? thread) {
    if (thread == null || _markingRead) {
      return;
    }
    // Not while the app is backgrounded/locked on this screen: nobody has
    // actually seen the message (R-102). didChangeAppLifecycleState catches up
    // on resume. Unknown (null) counts as foreground.
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    if (lifecycle != null && lifecycle != AppLifecycleState.resumed) {
      return;
    }
    final hasUnread = thread.items.any((m) => !m.mine && !m.deleted && m.status != ChatMessageStatus.read);
    if (!hasUnread) {
      return;
    }
    _markingRead = true;
    unawaited(
      ref
          .read(chatControllerProvider.notifier)
          .markRead(widget.friendId)
          .catchError((Object e) => logger.log('friends_on_map: mark read failed: $e'))
          .whenComplete(() => _markingRead = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final threadAsync = ref.watch(chatThreadProvider(widget.friendId));
    final outbox = ref.watch(chatOutboxProvider).value ?? const [];
    final pending = outbox.where((m) => m.friendId == widget.friendId).map((m) => m.toChatMessage());

    return Directionality(
      textDirection: ref.watch(uiDirectionProvider),
      child: Material(
        color: context.colors.backgroundSurface4,
        child: Scaffold(
          appBar: BaladyTopBar.iconAndText(
            title: widget.displayName,
            colorEnabled: context.colors.accentDefault,
            leading: ActionModel(onPressed: () => context.router.pop(), icon: SystemIcons.arrowCornerLeftLarge),
            trailing: ActionModel(onPressed: _showConversationActions, icon: SystemIcons.ellipsis),
          ),
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(child: _buildBody(context, threadAsync, pending.toList())),
                    if (_newBelow > 0)
                      Positioned(
                        bottom: Spacing.$2x,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: _NewMessagesPill(count: _newBelow, onTap: _scrollToBottom),
                        ),
                      ),
                  ],
                ),
              ),
              if (!_isUnavailable(threadAsync)) ChatInputBar(onSend: _sendText, onSendPlace: _sendPlace),
            ],
          ),
        ),
      ),
    );
  }

  // R-106: a 404 means the friendship ended or a block is in force — the
  // conversation is gone for both parties. Any other error (e.g. offline)
  // keeps showing what we already have.
  bool _isUnavailable(AsyncValue<ChatThreadState> thread) {
    final error = thread.error;
    return error is FriendsOnMapApiException && error.statusCode == 404;
  }

  // Renders the last known thread while a refetch is in flight: an event
  // from the socket invalidates the provider, and `when` would otherwise
  // flash a spinner (and lose the scroll position) on every incoming message.
  Widget _buildBody(BuildContext context, AsyncValue<ChatThreadState> threadAsync, List<ChatMessage> pending) {
    if (_isUnavailable(threadAsync)) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.$4x),
          child: Text(
            context.l10n.chatUnavailable,
            textAlign: TextAlign.center,
            style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundMuted),
          ),
        ),
      );
    }
    final thread = threadAsync.value;
    if (thread == null) {
      return const Center(child: CircularProgressIndicator());
    }
    // An event can deliver the server copy of a message before the PUT
    // response removes its outbox entry: show it once.
    final serverClientIds = {for (final m in thread.items) ?m.clientMessageId};
    final stillPending = pending.where((m) => !serverClientIds.contains(m.id)).toList();
    return _buildMessages(context, [...thread.items, ...stillPending]);
  }

  Widget _buildMessages(BuildContext context, List<ChatMessage> messages) {
    if (messages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.$4x),
          child: Text(
            context.l10n.chatThreadEmpty,
            textAlign: TextAlign.center,
            style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundMuted),
          ),
        ),
      );
    }
    // Newest at the bottom: a reversed list keeps the view pinned there as
    // messages arrive and makes "scrolled to the top" mean "load older".
    return ListView.builder(
      controller: _scroll,
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: Spacing.$2x),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[messages.length - 1 - index];
        final place = message.place;
        return ChatMessageBubble(
          message: message,
          onTap: message.status == ChatMessageStatus.failed ? () => _showMessageActions(message) : null,
          onLongPress: () => _showMessageActions(message),
          onOpenPlace: place == null || message.deleted
              ? null
              : () => openChatPlaceOnMap(ref, place, title: widget.displayName),
        );
      },
    );
  }

  void _sendText(String text) {
    _scrollToBottom();
    unawaited(
      runFriendsOnMapAction(context, () => ref.read(chatControllerProvider.notifier).sendText(widget.friendId, text)),
    );
  }

  Future<void> _sendPlace() async {
    final pick = await showMeetupPlacePickerSheet(context);
    if (pick == null || !mounted) {
      return;
    }
    _scrollToBottom();
    await runFriendsOnMapAction(
      context,
      () => ref
          .read(chatControllerProvider.notifier)
          .sendPlace(widget.friendId, latitude: pick.latitude, longitude: pick.longitude, label: pick.label),
    );
  }

  void _showMessageActions(ChatMessage message) {
    final l10n = context.l10n;
    final canDelete =
        message.mine &&
        !message.deleted &&
        message.seq != null &&
        DateTime.now().difference(message.displayTime) <= _kDeleteWindow;
    final canReport = !message.mine && !message.deleted;
    final failed = message.status == ChatMessageStatus.failed;
    if (!canDelete && !canReport && !failed) {
      return;
    }

    unawaited(
      _showActionsSheet([
        if (failed) _SheetAction(l10n.chatActionRetry, Icons.refresh, () => _retry(message)),
        if (failed)
          _SheetAction(l10n.chatActionDiscard, GeneralIcons.trash, () => _discard(message), destructive: true),
        if (canDelete)
          _SheetAction(l10n.chatActionDelete, GeneralIcons.trash, () => _confirmDelete(message), destructive: true),
        if (canReport)
          _SheetAction(l10n.chatActionReport, GeneralIcons.block, () => _confirmReport(message), destructive: true),
      ]),
    );
  }

  void _showConversationActions() {
    final l10n = context.l10n;
    unawaited(
      _showActionsSheet([
        _SheetAction(l10n.chatReportConversation, GeneralIcons.block, _confirmReportConversation, destructive: true),
      ]),
    );
  }

  Future<void> _showActionsSheet(List<_SheetAction> actions) => showModalBottomSheet<void>(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (sheetContext) => Container(
      decoration: BoxDecoration(
        color: context.colors.backgroundSurface4,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(RadiusBorder.xl)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.$4x),
          child: ContentWrapper(
            color: context.colors.backgroundSurface1,
            children: [
              for (var i = 0; i < actions.length; i++)
                ContentRow(
                  isDividerEnabled: i < actions.length - 1,
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    actions[i].onTap();
                  },
                  leading: Icon(
                    actions[i].icon,
                    color: actions[i].destructive ? context.colors.errorDefault : context.colors.foregroundMuted,
                  ),
                  text: ContentRowTextOptions(
                    title: actions[i].title,
                    titleOptions: actions[i].destructive
                        ? ContentRowTextOption(baseColor: context.colors.errorDefault)
                        : null,
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );

  void _retry(ChatMessage message) {
    unawaited(runFriendsOnMapAction(context, () => ref.read(chatControllerProvider.notifier).retry(message.id)));
  }

  void _discard(ChatMessage message) {
    unawaited(ref.read(chatControllerProvider.notifier).discard(message.id));
  }

  void _confirmDelete(ChatMessage message) {
    final l10n = context.l10n;
    showFriendConfirmSheet(
      context,
      title: l10n.chatDeleteConfirmTitle,
      body: l10n.chatDeleteConfirmBody,
      confirmLabel: l10n.chatActionDelete,
      onConfirm: () => _run((c) => c.deleteMessage(message.id)),
    );
  }

  void _confirmReport(ChatMessage message) {
    final l10n = context.l10n;
    showFriendConfirmSheet(
      context,
      title: l10n.chatReportConfirmTitle,
      body: l10n.chatReportConfirmBody,
      confirmLabel: l10n.chatActionReport,
      onConfirm: () => _run((c) => c.reportMessage(message.id)),
    );
  }

  void _confirmReportConversation() {
    final l10n = context.l10n;
    showFriendConfirmSheet(
      context,
      title: l10n.chatReportConversationConfirmTitle,
      body: l10n.chatReportConversationConfirmBody,
      confirmLabel: l10n.chatReportConversation,
      onConfirm: () => _run((c) => c.reportConversation(widget.friendId)),
    );
  }

  // Resolved off the root navigator's container at confirm-tap time, never a
  // captured WidgetRef — the lesson recorded in friends_on_map/AGENTS.md for
  // every callback that fires after the sheet that created it is gone.
  void _run(Future<void> Function(ChatController controller) action) {
    final rootContext = rootNavigatorKey.currentContext!;
    final controller = ProviderScope.containerOf(rootContext, listen: false).read(chatControllerProvider.notifier);
    unawaited(runFriendsOnMapAction(rootContext, () => action(controller)));
  }
}

class _SheetAction {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool destructive;

  const _SheetAction(this.title, this.icon, this.onTap, {this.destructive = false});
}

/// "N new messages" chip shown over the thread while the user is reading
/// history; tapping jumps to the newest message.
class _NewMessagesPill extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _NewMessagesPill({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    child: GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(color: context.colors.accentDefault, borderRadius: BorderRadius.circular(999)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$3x, vertical: Spacing.$2x),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_downward, size: 16, color: context.colors.foregroundDefaultInversion),
              const SizedBox(width: Spacing.$1x),
              Text(
                context.l10n.chatNewMessagesPill(count),
                style: context.textStyles.bodySmallSemiBold.copyWith(color: context.colors.foregroundDefaultInversion),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
