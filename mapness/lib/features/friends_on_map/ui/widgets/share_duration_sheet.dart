import 'package:balady_plus/app/core/utils/common_functions.dart' as balady_utils;
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/features/friends_on_map/models/share_duration_option.dart';
import 'package:mapness/features/friends_on_map/providers/active_shares_controller.dart';
import 'package:mapness/features/friends_on_map/ui/friends_on_map_error_dialog.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_share_sheet.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/deeplink_functions.dart';

/// R-78/R-79/R-80: the live-location share duration picker + pre-share
/// disclosure. Mirrors `features/share_eta/ui/eta_share_control_sheet/
/// eta_sharing_time_sheet.dart`'s single-select `ContentRow`-list shape, but
/// with the BRD's full 4 options (that file only has 3, missing 24h) and
/// new l10n keys, since this is a different backend/mechanism entirely.
class ShareDurationSheet extends HookConsumerWidget {
  const ShareDurationSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = useState(ShareDurationOption.oneHour);

    Widget checkmark(bool active) => active
        ? AppIcons(size: 24, iconData: SystemIcons.checkmark, color: context.colors.accentDefault)
        : const SizedBox(height: 24, width: 24);

    ContentRow optionRow(ShareDurationOption option, String label, {bool divider = true}) => ContentRow(
      onTap: () => selected.value = option,
      options: ContentRowOptions(
        dividerEnabled: divider,
        actionWidget: ContentRowActionOptions(
          toggleInitialValue: selected.value == option,
          customToggleBuilder: ({required onToggle, initial}) => checkmark(initial ?? false),
        ),
        title: label,
        titleStyle: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundDefault),
      ),
    );

    return EtaShareSheet(
      title: context.l10n.friendsOnMapShareLocationCta,
      confirmBtnTitle: context.l10n.share_location_btn,
      onConfirmTap: () => _confirm(context, ref, selected.value),
      contentBuilder: (context) => [
        Padding(
          padding: const EdgeInsets.only(bottom: Spacing.$3x),
          child: Text(
            context.l10n.friendsOnMapShareDisclosure,
            style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
          ),
        ),
        optionRow(ShareDurationOption.fifteenMinutes, context.l10n.friendsOnMapShareFor15Minutes),
        optionRow(ShareDurationOption.oneHour, context.l10n.friendsOnMapShareFor1Hour),
        optionRow(ShareDurationOption.eightHours, context.l10n.friendsOnMapShareFor8Hours),
        optionRow(ShareDurationOption.twentyFourHours, context.l10n.friendsOnMapShareFor24Hours, divider: false),
      ],
    );
  }

  Future<void> _confirm(BuildContext context, WidgetRef ref, ShareDurationOption option) async {
    await runFriendsOnMapAction(context, () async {
      final result = await ref.read(activeSharesControllerProvider.notifier).startLiveShare(option.duration);
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop();
      final shareUrl = BaldayDeeplink.urlWithQuery(BaldayDeeplink.baseShareUri, {
        BaldayDeeplink.shareTokenKey: result.token,
        BaldayDeeplink.typeKey: 'live',
      });
      balady_utils.safeShareText(shareUrl, context: context);
    });
  }
}
