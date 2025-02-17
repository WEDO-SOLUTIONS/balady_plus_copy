import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/balady_logo/balady_logo.dart';

class UnauthorizedProfile extends ConsumerWidget {
  const UnauthorizedProfile({super.key, this.onConnect});

  final VoidCallback? onConnect;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        children: [
          Spacing.$8x.heightBox,
          // TODO: Change size of BaladyLogo
          const BaladyLogo(
            height: 48,
            width: 127,
          ),
          Spacing.$4x.heightBox,
          SizedBox(
            width: 280,
            child: Text(
              // TODO: Change text in Localizy
              context.l10n.signInToUnlockTheFullPotentialOfTheBaladyApp,
              textAlign: TextAlign.center,
              style: context.textStyleV3.bodySmallRegular.copyWith(
                color: context.colorsV3.accentOnAccent,
              ),
            ),
          ),
          Spacing.$4x.heightBox,
          Row(
            children: [
              Expanded(
                child: BaladyAppButton(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                  primaryLabel: context.l10n.connectToMomrah,
                  buttonColorScheme: BaladyButtonColorScheme.accent,
                  onTap: onConnect,
                  textColor: context.colorsV3.accentOnAccent,
                  size: BaladyButtonSize.large,
                ),
              ),
            ],
          ),
          Spacing.$8x.heightBox,
        ],
      );
}
