import 'dart:async';
import 'dart:convert';

import 'package:mapness/features/friends_on_map/data/friends_on_map_api_exception.dart';
import 'package:mapness/features/friends_on_map/models/outbox_message.dart';
import 'package:mapness/features/friends_on_map/providers/chat_repository.dart';
import 'package:mapness/features/friends_on_map/providers/chat_thread.dart';
import 'package:mapness/features/friends_on_map/providers/conversations.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_outbox.g.dart';

const String _kOutboxBoxName = 'friends_on_map_chat_outbox';

/// R-103: the local queue of messages not yet acknowledged by the server.
/// Persisted in a Hive box as JSON strings (no Hive adapter, so nothing to
/// register in `entry_point.dart`) so a kill or relaunch never loses a
/// message; sending is idempotent on `clientMessageId`, so a re-send after
/// an ambiguous failure can never duplicate.
///
/// Policy: a network failure or 5xx leaves the message pending and stops the
/// flush (order is preserved; the next trigger — thread open, socket
/// reconnect, next send — resumes it). Any other refusal (4xx, a limit) marks
/// that one message failed: shown as "not sent", never auto-retried.
///
/// keepAlive: sends must outlive the chat screen being closed.
@Riverpod(keepAlive: true)
class ChatOutbox extends _$ChatOutbox {
  bool _flushing = false;

  @override
  Future<List<OutboxMessage>> build() async {
    final box = await ref.watch(hiveProvider(_kOutboxBoxName).future);
    final items = <OutboxMessage>[];
    for (final raw in box.values) {
      if (raw is! String) {
        continue;
      }
      try {
        items.add(OutboxMessage.fromJson(jsonDecode(raw) as Map<String, dynamic>));
      } on Object catch (e) {
        logger.log('friends_on_map: dropping unreadable outbox entry: $e');
      }
    }
    items.sort((a, b) => a.composedAt.compareTo(b.composedAt));
    if (items.any((i) => !i.failed)) {
      // Resume anything left over from a previous run — after build() has
      // resolved, since flush() reads this provider's own future.
      Future<void>.microtask(() => unawaited(flush()));
    }
    return items;
  }

  /// Persists [message] and starts sending. Returns the refusal that stopped
  /// it, if any (a limit the UI should explain), else null.
  Future<FriendsOnMapApiException?> enqueue(OutboxMessage message) async {
    final box = await ref.read(hiveProvider(_kOutboxBoxName).future);
    await box.put(message.clientMessageId, jsonEncode(message.toJson()));
    final current = await ref.read(chatOutboxProvider.future);
    if (!ref.mounted) {
      return null;
    }
    state = AsyncData([...current, message]);
    return flush();
  }

  /// Sends every pending message in composition order. Returns the first
  /// non-transient refusal hit, else null.
  Future<FriendsOnMapApiException?> flush() async {
    if (_flushing) {
      return null;
    }
    _flushing = true;
    FriendsOnMapApiException? firstRefusal;
    final attempted = <String>{};
    try {
      while (ref.mounted) {
        final items = await ref.read(chatOutboxProvider.future);
        final next = items.where((i) => !i.failed && !attempted.contains(i.clientMessageId)).firstOrNull;
        if (next == null) {
          break;
        }
        attempted.add(next.clientMessageId);
        try {
          final sent = await ref
              .read(chatRepositoryProvider)
              .sendMessage(
                friendId: next.friendId,
                clientMessageId: next.clientMessageId,
                kind: next.kind,
                composedAt: next.composedAt,
                body: next.body,
                place: next.place,
              );
          if (!ref.mounted) {
            return firstRefusal;
          }
          await _remove(next.clientMessageId);
          if (ref.mounted && ref.exists(chatThreadProvider(next.friendId))) {
            ref.read(chatThreadProvider(next.friendId).notifier).upsert(sent);
          }
        } on FriendsOnMapApiException catch (e) {
          if (!ref.mounted) {
            return firstRefusal;
          }
          if (_isTransient(e)) {
            // Keep it pending and stop: later messages must not overtake it.
            break;
          }
          firstRefusal ??= e;
          await _setFailed(next.clientMessageId, failed: true);
        }
      }
      if (ref.mounted) {
        ref.invalidate(conversationsProvider);
      }
    } finally {
      _flushing = false;
    }
    return firstRefusal;
  }

  /// Gives a failed message another go. Returns the refusal, if it fails
  /// again.
  Future<FriendsOnMapApiException?> retry(String clientMessageId) async {
    await _setFailed(clientMessageId, failed: false);
    return flush();
  }

  /// Drops a message (a failed one the user gave up on).
  Future<void> discard(String clientMessageId) => _remove(clientMessageId);

  bool _isTransient(FriendsOnMapApiException e) {
    final status = e.statusCode;
    return status == null || status >= 500;
  }

  Future<void> _remove(String clientMessageId) async {
    final box = await ref.read(hiveProvider(_kOutboxBoxName).future);
    await box.delete(clientMessageId);
    final current = await ref.read(chatOutboxProvider.future);
    if (!ref.mounted) {
      return;
    }
    state = AsyncData(current.where((i) => i.clientMessageId != clientMessageId).toList());
  }

  Future<void> _setFailed(String clientMessageId, {required bool failed}) async {
    final box = await ref.read(hiveProvider(_kOutboxBoxName).future);
    final current = await ref.read(chatOutboxProvider.future);
    final updated = [
      for (final item in current)
        if (item.clientMessageId == clientMessageId) item.copyWith(failed: failed) else item,
    ];
    final changed = updated.firstWhere((i) => i.clientMessageId == clientMessageId, orElse: () => current.first);
    if (changed.clientMessageId == clientMessageId) {
      await box.put(clientMessageId, jsonEncode(changed.toJson()));
    }
    if (!ref.mounted) {
      return;
    }
    state = AsyncData(updated);
  }
}
