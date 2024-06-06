import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/_features/common/providers/color_scheme.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class UnautorizedProfile extends ConsumerWidget {
  const UnautorizedProfile({super.key, this.onConnect});

  final VoidCallback? onConnect;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(
              ref.read(colorSchemeProvider) == AppColorScheme.brown
                  ? 'assets/images/log_in_card_brown.png'
                  : 'assets/images/log_in_card.png',
              package: PackageConfig.packageName,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 32,
            ),
            SizedBox(
              width: 95,
              height: 40,
              child: SvgPicture.asset(
                'assets/images_svg/balady_logo.svg',
                package: PackageConfig.packageName,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: 280,
              child: Text(
                context.l10n.signInToUnlockTheFullPotentialOfTheBaladyApp,
                textAlign: TextAlign.center,
                style: context.textStyle
                    .text
                    .copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    primaryLabel: context.l10n.connectToMomrah,
                    buttonColorScheme: ButtonColorScheme.onColor,
                    onTap: onConnect,
                    textColor: context.color.textAndIconsStatusAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      );
}
