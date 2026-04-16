import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:url_launcher/url_launcher.dart';



@RoutePage()
class PrivacyAndTermsOfUsePage extends StatelessWidget {
  const PrivacyAndTermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(NavigationService.navigatorKey.currentState!.context);
    const fontFamily = GeneralKey.appFontType ;
    // Custom style for the body text to match the screenshot spacing
    final TextStyle bodyStyle = theme.textTheme.bodyLarge!.copyWith(
      // height: 1.5,
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
              context.l10n.termAndConditions,
            style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: fontFamily),
          ),
          centerTitle: true,
          leading: BackButton(color: theme.primaryColor),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: context.isRTL ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Text(
                  context.isRTL
                      ? "يتولى تطبيق بلدي بياناتك الشخصية بأعلى درجات العناية، وتحرص على سرية معلوماتك من خلال تطبيق ضوابط ومعايير معتمدة لحماية البيانات عبر أنظمة آمنة. ويقوم التطبيق بجمع البيانات واستخدامها لأغراض تقديم خدمات ذات جودة عالية لجميع المستفيدين، مثل:"
                      : "The Balady App treats your personal data with the utmost care, safeguarding the confidentiality of your information through the application of approved controls and standards for data protection across secure systems. The App collects and uses data for the purposes of delivering high-quality services to all beneficiaries, including:",
                  textAlign: context.isRTL ? TextAlign.right : TextAlign.left,
                  style: bodyStyle,
                ),
                const SizedBox(height: 20),

                // Bullet Points
                _buildBullet(
                  context: context,
                    iconPath: 'assets/icons/svg/question-circle.svg',
                  text: context.isRTL ? "تقديم ودعم وتحسين الخدمات" : "The provision, support, and improvement of services.",
                    fontFamily: fontFamily
                ),
                _buildBullet(
                  context: context,
                    iconPath: 'assets/icons/svg/shield-user.svg',
                  text: context.isRTL ? "التأكد من هوية المستخدمين" : "User identity verification.",
                    fontFamily: fontFamily
                ),
                _buildBullet(
                  context: context,
                  iconPath: 'assets/icons/svg/triangle-exclamation.svg',
                  text: context.isRTL ? "معالجة الطلبات والشكاوى" : "the processing of requests and complaints.",
                    fontFamily: fontFamily,
                ),

                const SizedBox(height: 20),
                Text(
                  context.isRTL
                      ? "وذلك وفقاً للأنظمة والتشريعات ذات الصلة في المملكة العربية السعودية."
                      : "in accordance with applicable laws and regulations in the Kingdom of Saudi Arabia.",
                  textAlign: context.isRTL ? TextAlign.right : TextAlign.left,
                  style: bodyStyle,
                ),
                const SizedBox(height: 20),
                Text(
                  context.isRTL
                      ? "يجب على المستفيد من تطبيق بلدي، الاطلاع بشكل مستمر على الخصوصية وسرية المعلومات وتحديثاتها. علماً بأن التطبيق غير مطالب بالإعلان عن أية تحديثات تتم عليها، واستخدامك للتطبيق يعني اطلاعك وموافقتك عليها، وما يتم عليها من تعديلات مستمرة. إنك مسؤول بمفردك عن البيانات التي تشاركها من خلال التطبيق، وتمامها وصحتها وسلامتها."
                      : "Users of the Balady App are required to review this Privacy and Confidentiality of Information notice and its updates on a regular basis. Please note that the App is not obligated to announce any updates made to this notice. Your continued use of the App constitutes your acknowledgement of and agreement to this notice and any ongoing amendments. You are solely responsible for the accuracy, completeness, and integrity of any data you share through the App.",
                  textAlign: context.isRTL ? TextAlign.right : TextAlign.left,
                  style: bodyStyle,
                ),
                const SizedBox(height: 30),

                // Footer Link
                Align(
                  alignment: context.isRTL ? Alignment.centerRight : Alignment.centerLeft,
                  child: Wrap(
                    children: [Text(
                    context.isRTL ? "وللمزيد من التفاصيل، يمكنك زيارة" : "For more information, you can visit the",
                    style: bodyStyle,
                  ),
                    const SizedBox(width: 10),
                    GestureDetector(
                        onTap: () {
                          final Uri url = Uri.parse(
                              'https://balady.sa/ar/privacy-policy');
                          launchUrl(url, mode: LaunchMode.externalApplication);
                        },
                        child: Text(
                        context.isRTL ? "منصة بلدي" : "Balady App.",
                        style: bodyStyle.copyWith(
                          color: theme.primaryColor, // Brand teal
                          fontWeight: FontWeight.bold,
                          fontFamily: fontFamily,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),],),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBullet({required BuildContext context, required String iconPath, required String text, required String fontFamily}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        // mainAxisAlignment: context.isRTL ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (!context.isRTL) ...[
            SvgPicture.asset(iconPath, height: 20,),
            const SizedBox(width: 12),
          // ],
          Expanded(
            child: Text(
              text,
              textAlign: context.isRTL ? TextAlign.right : TextAlign.left,
              style:  TextStyle(fontSize: 16, height: 1.4, fontFamily: fontFamily),

            ),
          ),
          // if (context.isRTL) ...[
          //   const SizedBox(width: 12),
          //   Icon(icon, color: Theme.of(context).primaryColor, size: 22),
          // ],
        ],
      ),
    );
}