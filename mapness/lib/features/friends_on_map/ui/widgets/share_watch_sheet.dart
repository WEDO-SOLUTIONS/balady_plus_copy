import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/friends_on_map/friend_elapsed_time.dart';
import 'package:mapness/features/friends_on_map/models/share_watch_state.dart';
import 'package:mapness/features/friends_on_map/providers/share_watcher.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_share_sheet.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// R-81/R-83's recipient-side "stop watching" sheet for a live-mode share —
/// reuses [EtaShareSheet] verbatim as the shell, same cross-feature-reuse
/// precedent as `friend_card_sheet.dart`. The content row now actually
/// watches [ShareWatchState] (previously a hardcoded `const []`, giving no
/// live feedback at all — a "still connecting" and a silently-failed watch
/// looked pixel-identical during QA; see the AGENTS.md QA-fix note).
bool _isShareWatchSheetOpen = false;

void showShareWatchSheet(BuildContext context) {
  // Defensive re-entrancy guard, same shape (and same underlying cause) as
  // `friend_card_sheet.dart`'s `showFriendCardSheet`/`_isFriendCardSheetOpen`
  // — belt-and-suspenders against duplicate marker `onTap`s stacking more
  // than one sheet (see the AGENTS.md follow-up note for the root cause:
  // overlapping `ShareWatchMarker.build()` invocations can leave duplicate
  // markers, each with its own independently-captured `onTap`).
  if (_isShareWatchSheetOpen) {
    return;
  }
  _isShareWatchSheetOpen = true;
  showModalBottomSheet<void>(
    backgroundColor: Colors.transparent,
    context: context,
    isScrollControlled: true,
    builder: (context) => Consumer(
      builder: (_, ref, __) => EtaShareSheet(
        title: context.l10n.shareWatchSheetTitle,
        confirmBtnTitle: context.l10n.stopSharing,
        onConfirmTap: () {
          Navigator.of(context).pop();
          ref.read(shareWatcherProvider.notifier).stopWatching();
        },
        contentBuilder: (context) {
          final watchState = ref.watch(shareWatcherProvider);
          final name = watchState.sharerDisplayName;
          return [
            // R-81: the link holder sees who is sharing, not just where.
            if (name != null && name.isNotEmpty) ContentRow(text: ContentRowTextOptions(title: name)),
            _StatusRow(watchState),
          ];
        },
      ),
    ),
  ).whenComplete(() => _isShareWatchSheetOpen = false);
}

class _StatusRow extends StatelessWidget {
  const _StatusRow(this.watchState);

  final ShareWatchState watchState;

  @override
  Widget build(BuildContext context) {
    final label = switch (watchState.status) {
      ShareWatchStatus.connecting => context.l10n.shareWatchConnecting,
      ShareWatchStatus.expired => context.l10n.shareExpiredTitle,
      ShareWatchStatus.live =>
        watchState.at == null
            ? context.l10n.shareWatchConnecting
            : friendElapsedTimeLabel(context.l10n, watchState.at!),
    };
    return ContentRow(text: ContentRowTextOptions(title: label));
  }
}
