import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';

const momrahEmail = 'infoCS@momah.gov.sa';
const momrahPoneNumber = '199040';
const momrahTwitter = r'Balady_saudi';

class ContactInfo extends StatefulWidget {
  final Color colorBegin;
  final Color colorEnd;

  const ContactInfo({
    required this.colorBegin,
    required this.colorEnd,
    super.key,
  });

  @override
  State<ContactInfo> createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> with SingleTickerProviderStateMixin {
  @override
  void dispose() {
    if (rootNavigatorKey.currentContext != null) {
      ScaffoldMessenger.of(rootNavigatorKey.currentContext!).hideCurrentSnackBar();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDGA =
        context.read<ThemeController>().currentTheme == BaladyAppThemes.darkDGA ||
            context.read<ThemeController>().currentTheme == BaladyAppThemes.lightDGA;

    return Column(
        children: [
          ContentWrapper(
            color: isDGA ? context.colors.accentSecondarySoft : context.colors.backgroundSurface1,
            children: [
              ContentRow(
                isDividerEnabled: true,
                onTap: () => CommonFunctions.launch('https://twitter.com/Balady_saudi'),
                leading: AppIcons(
                  iconData: SocialIcons.twitter,
                  color: context.colors.accentDefault,
                ),
                text: ContentRowTextOptions(
                  // text hack for rtl @ symbol, it's not supported in flutter
                  title: context.isLTR ? '@$momrahTwitter' : '$momrahTwitter@',
                  subtitle: context.l10n.twitterAccount,
                ),
                trailing: ContentRowTextTrailingOptions(
                  icon: SystemIcons.arrowCornerRightSmall,
                  iconColor: context.colors.foregroundSoft,
                ),
              ),
              ContentRow(
                isDividerEnabled: true,
                onTap: () => CommonFunctions.call(momrahPoneNumber),
                leading: AppIcons(
                  iconData: switch (Directionality.of(context)) {
                    TextDirection.ltr => GeneralIcons.phoneLTR,
                    TextDirection.rtl => GeneralIcons.phoneRTL,
                  },
                  color: context.colors.accentDefault,
                ),
                text: ContentRowTextOptions(
                  title: momrahPoneNumber,
                  subtitle: context.l10n.profileContactInformation,
                ),
                trailing: ContentRowTextTrailingOptions(
                  icon: SystemIcons.arrowCornerRightSmall,
                  iconColor: context.colors.foregroundSoft,
                ),
              ),
              ContentRow(
                onTap: () => CommonFunctions.email(momrahEmail),
                leading: AppIcons(
                  iconData: GeneralIcons.mail,
                  color: context.colors.accentDefault,
                ),
                text: ContentRowTextOptions(
                  title: momrahEmail,
                  subtitle: context.l10n.email,
                ),
                trailing: ContentRowTextTrailingOptions(
                  icon: SystemIcons.arrowCornerRightSmall,
                  iconColor: context.colors.foregroundSoft,
                ),
              ),
            ],
          ),
        ],
      );
  }
}
