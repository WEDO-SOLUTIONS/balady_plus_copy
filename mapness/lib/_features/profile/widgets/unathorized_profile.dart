import 'package:balady_uikit/colors/app_color_scheme.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/_features/common/providers/color_scheme.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class UnautorizedProfile extends ConsumerWidget {
  final VoidCallback? onConnect;

  const UnautorizedProfile({super.key, this.onConnect});

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
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .textM
                    .copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: onConnect,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.l10n.connectToMomrah,
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()!
                              .accentM
                              .copyWith(
                                  color: context
                                      .color.text_and_icons_status_accent),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      );
}
