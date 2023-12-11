import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class UnautorizedProfile extends StatelessWidget {
  final VoidCallback? onConnect;
  const UnautorizedProfile({super.key, this.onConnect});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 268,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox.fromSize(
                size: const Size.fromRadius(48),
                child: const Image(
                  image: AssetImage(
                    'assets/images/log_in_card.png',
                    package: PackageConfig.packageName,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              top: 32,
              bottom: 18,
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
                                  .copyWith(color: const Color(0xFF1E928F)),
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
          ),
        ],
      ),
    );
  }
}
