import 'package:balady_plus/app/core/utils/common_functions.dart' as balady_utils;
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/features/friends_on_map/providers/active_shares_controller.dart';
import 'package:mapness/features/friends_on_map/ui/friends_on_map_error_dialog.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/deeplink_functions.dart';

// R-85: a share must have a real expiry, but this one-tap entry point
// (mirroring share_eta's own ShareEtaBtn, which also has no duration
// picker) has nowhere to ask for a duration — 8 hours comfortably outlasts
// any single turn-by-turn trip without leaving a share dangling for a full
// day. Flagged as a deliberate simplification, not a BRD requirement.
const Duration _kEtaShareDuration = Duration(hours: 8);

/// S-19/R-85's second, new ETA-mode share entry point — a sibling to (not a
/// replacement of) `features/share_eta/ui/share_eta_btn.dart`'s existing
/// button in the same nav panel (see `widgets/path_nav/ui/navi_sheet_panel.dart`).
/// Only reachable while turn-by-turn navigation is active, same gating as
/// the old button — `pathNavEtaProvider` is structurally null otherwise, so
/// there's nowhere else this could plausibly live yet (see
/// `friends_on_map/AGENTS.md`'s S-19 slice notes).
class FriendsOnMapEtaShareBtn extends HookConsumerWidget {
  final double destLat;
  final double destLon;

  const FriendsOnMapEtaShareBtn({required this.destLat, required this.destLon, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);

    return ContentRow(
      onTap: isLoading.value ? null : () => _start(context, ref, isLoading),
      options: ContentRowOptions(
        wrapperColor: context.colors.backgroundSurface1,
        wrapperEnabled: true,
        title: context.l10n.friendsOnMapShareEtaCta,
        titleStyle: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundDefault),
        customActionWidget: isLoading.value
            ? const Padding(
                padding: EdgeInsetsDirectional.only(end: Spacing.$4x),
                child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)),
              )
            : null,
      ),
    );
  }

  Future<void> _start(BuildContext context, WidgetRef ref, ValueNotifier<bool> isLoading) async {
    isLoading.value = true;
    await runFriendsOnMapAction(context, () async {
      final result = await ref
          .read(activeSharesControllerProvider.notifier)
          .startEtaShare(_kEtaShareDuration, destLat: destLat, destLon: destLon);
      if (!context.mounted) {
        return;
      }
      final shareUrl = BaldayDeeplink.urlWithQuery(BaldayDeeplink.baseShareUri, {
        BaldayDeeplink.shareTokenKey: result.token,
        BaldayDeeplink.typeKey: 'eta',
      });
      balady_utils.safeShareText(shareUrl, context: context);
    });
    isLoading.value = false;
  }
}
