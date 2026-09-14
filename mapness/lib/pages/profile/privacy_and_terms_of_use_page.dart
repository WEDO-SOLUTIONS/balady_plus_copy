import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class PrivacyAndTermsOfUsePage extends StatelessWidget {
  const PrivacyAndTermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(NavigationService.navigatorKey.currentState!.context);
    const fontFamily = GeneralKey.appFontType;

    final TextStyle bodyStyle = theme.textTheme.bodyLarge!.copyWith(
      fontSize: 16,
      fontFamily: fontFamily,
    );

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'privacyAndTermsTitle'.tr(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: fontFamily,
            ),
          ),
          centerTitle: true,
          leading: Semantics(
            label: context.l10n.a11yBack,
            button: true,
            excludeSemantics: true,
            child: BackButton(color: theme.primaryColor),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: context.isRTL ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Text(
                  'privacyIntroText'.tr(),
                  textAlign: context.isRTL ? TextAlign.right : TextAlign.left,
                  style: bodyStyle,
                ),
                const SizedBox(height: 20),
                _buildBullet(
                  context: context,
                  iconPath: 'assets/icons/svg/question-circle.svg',
                  text: 'privacyBulletServices'.tr(),
                  fontFamily: fontFamily,
                ),
                _buildBullet(
                  context: context,
                  iconPath: 'assets/icons/svg/shield-user.svg',
                  text: 'privacyBulletIdentity'.tr(),
                  fontFamily: fontFamily,
                ),
                _buildBullet(
                  context: context,
                  iconPath: 'assets/icons/svg/triangle-exclamation.svg',
                  text: 'privacyBulletRequests'.tr(),
                  fontFamily: fontFamily,
                ),
                const SizedBox(height: 20),
                Text(
                  'privacySaudiRegulationsText'.tr(),
                  textAlign: context.isRTL ? TextAlign.right : TextAlign.left,
                  style: bodyStyle,
                ),
                const SizedBox(height: 20),
                Text(
                  'privacyUserResponsibilityText'.tr(),
                  textAlign: context.isRTL ? TextAlign.right : TextAlign.left,
                  style: bodyStyle,
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: context.isRTL ? Alignment.centerRight : Alignment.centerLeft,
                  child: Wrap(
                    children: [
                      Text(
                        'privacyMoreDetailsText'.tr(),
                        style: bodyStyle,
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          final Uri url = Uri.parse('https://balady.sa/ar/privacy-policy');
                          launchUrl(url, mode: LaunchMode.externalApplication);
                        },
                        child: Text(
                          'privacyBaladyPlatformText'.tr(),
                          style: bodyStyle.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: fontFamily,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBullet({
    required BuildContext context,
    required String iconPath,
    required String text,
    required String fontFamily,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(iconPath, height: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            textAlign: context.isRTL ? TextAlign.right : TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              height: 1.4,
              fontFamily: fontFamily,
            ),
          ),
        ),
      ],
    ),
  );
}
