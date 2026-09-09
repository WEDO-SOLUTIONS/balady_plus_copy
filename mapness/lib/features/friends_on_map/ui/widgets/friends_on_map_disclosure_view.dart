import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// R-02: shown before any OS permission prompt (S-01).
class FriendsOnMapDisclosureView extends StatelessWidget {
  final VoidCallback onActivate;
  final VoidCallback onNotNow;

  const FriendsOnMapDisclosureView({required this.onActivate, required this.onNotNow, super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(Spacing.$4x),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.friendsOnMapDisclosureTitle,
          style: context.textStyles.h3SemiBold.copyWith(color: context.colors.foregroundDefault),
        ),
        const SizedBox(height: Spacing.$3x),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Bullet(context.l10n.friendsOnMapDisclosureWhatIsShared),
                _Bullet(context.l10n.friendsOnMapDisclosureWithWhom),
                _Bullet(context.l10n.friendsOnMapDisclosureNoHistory),
                // TODO(BE-213): revisit once the check-ins story (S-16) ships —
                // this line is currently a static fact, not derived state.
                _Bullet(context.l10n.friendsOnMapDisclosureCheckInsNotWithdrawn),
              ],
            ),
          ),
        ),
        const SizedBox(height: Spacing.$3x),
        AppButton(
          buttonColorScheme: ButtonColorScheme.accentSecondary,
          size: ButtonSize.large,
          primaryLabel: context.l10n.friendsOnMapActivateCta,
          onTap: onActivate,
        ),
        const SizedBox(height: Spacing.$2x),
        AppButton(
          buttonColorScheme: ButtonColorScheme.accentSecondary,
          buttonType: ButtonType.secondary,
          size: ButtonSize.large,
          primaryLabel: context.l10n.friendsOnMapNotNowCta,
          onTap: onNotNow,
        ),
      ],
    ),
  );
}

class _Bullet extends StatelessWidget {
  final String text;

  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: Spacing.$1_5x),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 7),
          child: Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: context.colors.foregroundMuted, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(width: Spacing.$2x),
        Expanded(
          child: Text(
            text,
            style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundDefault),
          ),
        ),
      ],
    ),
  );
}
