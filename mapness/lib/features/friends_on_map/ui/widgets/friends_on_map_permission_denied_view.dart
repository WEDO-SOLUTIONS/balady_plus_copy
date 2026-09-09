import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// R-05: shown when the OS foreground location permission (or the location
/// service itself) is denied — explains the situation and routes to OS
/// settings, same branch logic as `LocationErrorSheetPage.onRetry`.
class FriendsOnMapPermissionDeniedView extends StatelessWidget {
  final VoidCallback onOpenSettings;

  const FriendsOnMapPermissionDeniedView({required this.onOpenSettings, super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(Spacing.$4x),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.l10n.friendsOnMapForegroundDeniedTitle,
          textAlign: TextAlign.center,
          style: context.textStyles.h3SemiBold.copyWith(color: context.colors.foregroundDefault),
        ),
        const SizedBox(height: Spacing.$2x),
        Text(
          context.l10n.friendsOnMapForegroundDeniedBody,
          textAlign: TextAlign.center,
          style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundMuted),
        ),
        const SizedBox(height: Spacing.$4x),
        AppButton(
          buttonColorScheme: ButtonColorScheme.accentSecondary,
          size: ButtonSize.large,
          primaryLabel: context.l10n.friendsOnMapOpenSettingsCta,
          onTap: onOpenSettings,
        ),
      ],
    ),
  );
}
