import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/balady_logo/balady_logo.dart';

class UnautorizedProfile extends ConsumerWidget {
  const UnautorizedProfile({super.key, this.onConnect});

  final VoidCallback? onConnect;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColor.authBackgroundColorV2,
        ),
        child: Column(
          children: [
            Spacing.$8x.heightBox,
            const BaladyLogo(),
            Spacing.$6x.heightBox,
            SizedBox(
              width: 280,
              child: Text(
                context.l10n.signInToUnlockTheFullPotentialOfTheBaladyApp,
                textAlign: TextAlign.center,
                style: context.textStyle.text.copyWith(color: AppColor.authTitleColorV2),
              ),
            ),
            Spacing.$4x.heightBox,
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                    primaryLabel: context.l10n.connectToMomrah,
                    buttonColorScheme: ButtonColorScheme.onColor,
                    onTap: onConnect,
                    textColor: AppColor.authTitleColorV2,
                  ),
                ),
              ],
            ),
            Spacing.$4x.heightBox,
          ],
        ),
      );
}
