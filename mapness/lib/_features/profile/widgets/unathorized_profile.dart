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
      height: 248,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          SvgPicture.asset(
            'assets/images_svg/profile_background.svg',
            package: PackageConfig.packageName,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              top: 35,
              bottom: 43,
            ),
            child: Column(
              children: [
                const SizedBox(
                  width: 95,
                  height: 40,
                  child: Image(
                    image: AssetImage(
                      'assets/images/balady_logo.png',
                      package: PackageConfig.packageName,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  context.l10n.signInToUnlockTheFullPotentialOfTheBaladyApp,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .textM
                      .copyWith(color: const Color(0xFF1E2A36)),
                ),
                const SizedBox(
                  height: 20,
                ),
                Material(
                  color: const Color(0xFF4CA5B4),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                      onTap: onConnect,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 13,
                          right: 13,
                          top: 9,
                          bottom: 12,
                        ),
                        child: Center(
                          child: Text(
                            context.l10n.connectToMomrah,
                            style: Theme.of(context)
                                .extension<ThemeTextStyles>()!
                                .textL
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}
