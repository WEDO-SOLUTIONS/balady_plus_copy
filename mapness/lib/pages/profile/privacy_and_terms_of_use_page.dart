import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class PrivacyAndTermsOfUsePage extends StatelessWidget {
  const PrivacyAndTermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    const fontFamily = GeneralKey.appFontType;
    final colors = context.colors;
    final textStyles = context.textStyles;

    final TextStyle bodyStyle = textStyles.bodyLargeRegular.copyWith(
      fontSize: 16,
      fontFamily: fontFamily,
      color: colors.foregroundDefault,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Material(
        color: colors.backgroundSurface4,
        child: Padding(
          padding: const EdgeInsets.only(top: Spacing.$4x),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: BaladyTopBar.iconAndText(
              systemUiOverlayStyle: SystemUiOverlayStyle.dark,
              title: 'privacyAndTermsTitle'.tr(),
              colorEnabled: colors.accentDefault,
              leading: ActionModel(
                onPressed: () => context.router.pop(),
                icon: SystemIcons.arrowCornerLeftLarge,
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: context.isRTL
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
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
                      bodyStyle: bodyStyle,
                    ),
                    _buildBullet(
                      context: context,
                      iconPath: 'assets/icons/svg/shield-user.svg',
                      text: 'privacyBulletIdentity'.tr(),
                      bodyStyle: bodyStyle,
                    ),
                    _buildBullet(
                      context: context,
                      iconPath: 'assets/icons/svg/triangle-exclamation.svg',
                      text: 'privacyBulletRequests'.tr(),
                      bodyStyle: bodyStyle,
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
                                color: colors.accentDefault,
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
        ),
      ),
    );
  }

  Widget _buildBullet({
    required BuildContext context,
    required String iconPath,
    required String text,
    required TextStyle bodyStyle,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              iconPath,
              height: 20,
              colorFilter: ColorFilter.mode(context.colors.accentDefault, BlendMode.srcIn),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                textAlign: context.isRTL ? TextAlign.right : TextAlign.left,
                style: bodyStyle.copyWith(height: 1.4),
              ),
            ),
          ],
        ),
      );
}
