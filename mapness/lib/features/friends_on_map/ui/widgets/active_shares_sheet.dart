import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/friends_on_map/models/active_share.dart';
import 'package:mapness/features/friends_on_map/providers/active_shares_controller.dart';
import 'package:mapness/features/friends_on_map/ui/friends_on_map_error_dialog.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_share_sheet.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';

/// R-83: lists this account's own active shares with remaining time + a
/// stop action per row.
class ActiveSharesSheet extends ConsumerWidget {
  const ActiveSharesSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sharesAsync = ref.watch(activeSharesControllerProvider);

    return EtaShareSheet(
      title: context.l10n.friendsOnMapMyActiveSharesTitle,
      contentBuilder: (context) => sharesAsync.when(
        data: (shares) => shares.isEmpty
            ? [
                Padding(
                  padding: const EdgeInsets.all(Spacing.$4x),
                  child: Text(
                    context.l10n.friendsOnMapNoActiveSharesBody,
                    style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundMuted),
                  ),
                ),
              ]
            : shares.map((share) => _ActiveShareRow(share: share)).toList(),
        loading: () => [const Center(child: CircularProgressIndicator())],
        error: (_, _) => const [],
      ),
    );
  }
}

class _ActiveShareRow extends ConsumerWidget {
  final ActiveShare share;

  const _ActiveShareRow({required this.share});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remaining = share.expiresAt.difference(DateTime.now());
    final remainingLabel = remaining.isNegative ? '--' : remaining.inSeconds.formatDuration(context.l10n);

    return ContentRow(
      isDividerEnabled: true,
      text: ContentRowTextOptions(title: context.l10n.friendsOnMapActiveShareRemaining(remainingLabel)),
      trailing: ContentRowCustomTrailingOptions(
        builder: (_) => AppButton(
          buttonColorScheme: ButtonColorScheme.accentSecondary,
          buttonType: ButtonType.secondary,
          size: ButtonSize.small,
          primaryLabel: context.l10n.stopSharing,
          onTap: () => runFriendsOnMapAction(
            context,
            () => ref.read(activeSharesControllerProvider.notifier).stop(share.id),
          ),
        ),
      ),
    );
  }
}
