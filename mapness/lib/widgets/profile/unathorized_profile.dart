import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class UnautorizedProfile extends ConsumerWidget {
  const UnautorizedProfile({super.key, this.onConnect});

  final VoidCallback? onConnect;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromRGBO(48, 205, 194, 1),
        ),
        child: Column(
          children: [
            Spacing.$8x.heightBox,
            SizedBox(
              width: 95,
              height: Spacing.$10x,
              child: SvgPicture.asset(
                context.isLTR ? 'assets/images_svg/en_balady_logo.svg' : 'assets/images_svg/ar_balady_logo.svg',
                fit: BoxFit.cover,
                package: PackageConfig.packageName,
              ),
            ),
            Spacing.$6x.heightBox,
            SizedBox(
              width: 280,
              child: Text(
                context.l10n.signInToUnlockTheFullPotentialOfTheBaladyApp,
                textAlign: TextAlign.center,
                style: context.textStyle.text.copyWith(color: const Color.fromRGBO(1, 53, 74, 1)),
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
                    textColor: const Color.fromRGBO(0, 52, 73, 1),
                  ),
                ),
              ],
            ),
            Spacing.$4x.heightBox,
          ],
        ),
      );
}
