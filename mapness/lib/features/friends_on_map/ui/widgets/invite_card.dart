import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_invite_link.dart';
import 'package:mapness/features/friends_on_map/ui/friends_on_map_error_dialog.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/profile/profile_image/profile_image_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// R-26: own picture + display name + QR encoding the invite link, on a
/// card. R-27 (reset) and R-28 (share) live here as the card's actions.
class InviteCard extends ConsumerWidget {
  const InviteCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linkAsync = ref.watch(friendsOnMapInviteLinkProvider);
    final userInfo = CommonProperties.userInfo;

    return Container(
      padding: const EdgeInsets.all(Spacing.$4x),
      decoration: BoxDecoration(
        color: context.colors.backgroundSurface1,
        borderRadius: BorderRadius.circular(RadiusBorder.l),
      ),
      child: Column(
        children: [
          ProfileImageWidget(dimension: AvatarSize.$64, abbreviatedName: userInfo?.getAbbreviatedName()),
          const SizedBox(height: Spacing.$2x),
          Text(
            userInfo?.getFirstAndLastName() ?? '',
            style: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
          ),
          const SizedBox(height: Spacing.$4x),
          linkAsync.when(
            data: (link) => _LinkContent(link: link),
            loading: () => const Padding(
              padding: EdgeInsets.all(Spacing.$4x),
              child: CircularProgressIndicator(),
            ),
            error: (_, _) => Text(
              context.l10n.addFriendLoadError,
              style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.errorDefault),
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkContent extends ConsumerWidget {
  final String link;

  const _LinkContent({required this.link});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    children: [
      QrImageView(data: link, size: 180),
      const SizedBox(height: Spacing.$3x),
      Text(
        link,
        textAlign: TextAlign.center,
        style: context.textStyles.captionLargeRegular.copyWith(color: context.colors.foregroundMuted),
      ),
      const SizedBox(height: Spacing.$4x),
      AppButton(
        buttonColorScheme: ButtonColorScheme.accentSecondary,
        size: ButtonSize.large,
        primaryLabel: context.l10n.addFriendShareCta,
        onTap: () => safeShareText(link, context: context),
      ),
      const SizedBox(height: Spacing.$2x),
      AppButton(
        buttonColorScheme: ButtonColorScheme.accentSecondary,
        buttonType: ButtonType.secondary,
        size: ButtonSize.large,
        primaryLabel: context.l10n.addFriendResetCta,
        onTap: () => runFriendsOnMapAction(context, () => ref.read(friendsOnMapInviteLinkProvider.notifier).reset()),
      ),
    ],
  );
}
