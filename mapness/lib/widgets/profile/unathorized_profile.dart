import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/balady_logo/balady_logo.dart';

class UnauthorizedProfile extends ConsumerWidget {
  const UnauthorizedProfile({super.key, this.onConnect});

  final VoidCallback? onConnect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFoundingDay = ref.watch(activeCityEventProvider)?.isFoundingDay ?? false;
    final logoColor = isFoundingDay ? context.colors.accentSecondaryActive : context.colors.accentOnAccent;
    final buttonColorScheme = isFoundingDay ? ButtonColorScheme.accentSecondary : ButtonColorScheme.accent;
    return Column(
      children: [
        Spacing.$8x.heightBox,
        BaladyLogo(height: 48, width: 127, color: logoColor),
        Spacing.$4x.heightBox,
        SizedBox(
          width: 280,
          child: Text(
            context.l10n.signInToUnlockTheFullPotentialOfTheBaladyApp,
            textAlign: TextAlign.center,
            style: context.textStyles.bodySmallRegular.copyWith(color: logoColor),
          ),
        ),
        Spacing.$4x.heightBox,
        SizedBox(
          width: double.infinity,
          child: AppButton(
            color: context.colors.backgroundSurface5,
            textColor: context.colors.foregroundDefault,
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
            primaryLabel: context.l10n.connectToMomrah,
            size: ButtonSize.large,
            buttonColorScheme: buttonColorScheme,
            onTap: onConnect,
          ),
        ),
        Spacing.$4x.heightBox,
      ],
    );
  }
}
