import 'dart:io';

import 'package:balady_plus/app/features/entry_point/entry_point_exports.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/profile/widgets/profile_header.dart';
import 'package:mapness/_features/profile/widgets/profile_image_widget.dart';
import 'package:mapness/_features/profile/widgets/unathorized_profile.dart';
import 'package:mapness/app/routes/profile.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:rate_my_app/rate_my_app.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    RateMyApp rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp_',
      minDays: 0, // Show rate popup on first day of install.
      minLaunches:
          5, // Show rate popup after 5 launches of app after minDays is passed.
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Material(
          color: Colors.white,
          child: ListView(
            children: [
              const SafeArea(
                bottom: false,
                child: ProfileHeader(),
              ),
              const SizedBox(
                height: 6,
              ),
              Consumer(
                builder: (context, ref, child) {
                  final userData = ref.watch(authProvider);
                  final userUnauthorized = UnautorizedProfile(
                    onConnect: ref.read(authProvider.notifier).doAuth,
                  );
                  return userData.maybeWhen(
                    orElse: () => userUnauthorized,
                    data: (userData) => userData == null
                        ? userUnauthorized
                        : AuthorizedRow(
                            userData: userData,
                          ),
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SizedBox(
                  height: 52,
                  child: Material(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFF5F7FA),
                    child: InkWell(
                      onTap: () {
                        const SettingsRoute().push(context);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 16.0,
                            ),
                            SvgPicture.asset(
                              'assets/icons/svg/ic_chevron_left.svg',
                              height: 24,
                              width: 24,
                              package: PackageConfig.packageName,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF1E2A36),
                                BlendMode.srcIn,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "Settings",
                              style: Theme.of(context)
                                  .extension<ThemeTextStyles>()!
                                  .textM
                                  .copyWith(color: const Color(0xFF1E2A36)),
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            SvgPicture.asset(
                              'assets/images_svg/profile_settings.svg',
                              height: 24,
                              width: 24,
                              package: PackageConfig.packageName,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF1E928F),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SizedBox(
                  height: 52,
                  child: Material(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    color: const Color(0xFFF5F7FA),
                    child: InkWell(
                      onTap: () {
                        const HelpCenterRoute().push(context);
                      },
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 16.0,
                            ),
                            SvgPicture.asset(
                              'assets/icons/svg/ic_chevron_left.svg',
                              height: 24,
                              width: 24,
                              package: PackageConfig.packageName,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF1E2A36),
                                BlendMode.srcIn,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "Help Center",
                              style: Theme.of(context)
                                  .extension<ThemeTextStyles>()!
                                  .textM
                                  .copyWith(color: const Color(0xFF1E2A36)),
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            SvgPicture.asset(
                              'assets/images_svg/profile_help.svg',
                              height: 24,
                              width: 24,
                              package: PackageConfig.packageName,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF1E928F),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  color: const Color(0xFFF5F7FA),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 52),
                    child: Divider(
                      height: 1,
                      color: const Color(0xFF1E2A36).withOpacity(0.2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SizedBox(
                  height: 52,
                  child: Material(
                    color: const Color(0xFFF5F7FA),
                    child: InkWell(
                      onTap: () {
                        const AboutBaladyRoute().push(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 16.0,
                            ),
                            SvgPicture.asset(
                              'assets/icons/svg/ic_chevron_left.svg',
                              height: 24,
                              width: 24,
                              package: PackageConfig.packageName,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF1E2A36),
                                BlendMode.srcIn,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "About the application",
                              style: Theme.of(context)
                                  .extension<ThemeTextStyles>()!
                                  .textM
                                  .copyWith(color: const Color(0xFF1E2A36)),
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            SvgPicture.asset(
                              'assets/images_svg/profile_info.svg',
                              height: 24,
                              width: 24,
                              package: PackageConfig.packageName,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF1E928F),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  color: const Color(0xFFF5F7FA),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 52),
                    child: Divider(
                      height: 1,
                      color: const Color(0xFF1E2A36).withOpacity(0.2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SizedBox(
                  height: 52,
                  child: Material(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    color: const Color(0xFFF5F7FA),
                    child: InkWell(
                      onTap: () {
                        rateMyApp.showRateDialog(
                          context,
                          title: 'Rate this app',
                          message:
                              'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.', // The dialog message.
                          rateButton: 'RATE',
                          noButton: 'NO THANKS',
                          laterButton: 'MAYBE LATER',
                          listener: (button) {
                            switch (button) {
                              case RateMyAppDialogButton.rate:
                                break;
                              case RateMyAppDialogButton.later:
                                break;
                              case RateMyAppDialogButton.no:
                                break;
                            }

                            return true;
                          },
                          ignoreNativeDialog: Platform.isAndroid,
                          dialogStyle: const DialogStyle(),
                          onDismissed: () => rateMyApp
                              .callEvent(RateMyAppEventType.laterButtonPressed),
                        );
                      },
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 16.0,
                            ),
                            SvgPicture.asset(
                              'assets/icons/svg/ic_chevron_left.svg',
                              height: 24,
                              width: 24,
                              package: PackageConfig.packageName,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF1E2A36),
                                BlendMode.srcIn,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "Rate Balady App",
                              style: Theme.of(context)
                                  .extension<ThemeTextStyles>()!
                                  .textM
                                  .copyWith(color: const Color(0xFF1E2A36)),
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            SvgPicture.asset(
                              'assets/images_svg/profile_star.svg',
                              height: 24,
                              width: 24,
                              package: PackageConfig.packageName,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF1E928F),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Consumer(
              //   builder: (context, ref, child) {
              //     final userData = ref.watch(authProvider);

              //     return userData.maybeWhen(
              //       orElse: () => const SizedBox.shrink(),
              //       data: (userData) {
              //         if (userData == null) return const SizedBox.shrink();
              //         return Padding(
              //           padding: const EdgeInsets.only(top: 16.0),
              //           child: ExpandableCell(
              //             title: context.l10n.personalData,
              //             count: 7,
              //             icon: "assets/icons/svg/ic_profile_data.svg",
              //             content: PersonalData(
              //               userInfo: userData,
              //             ),
              //           ),
              //         );
              //       },
              //     );
              //   },
              // ),
              // const SizedBox(
              //   height: 16,
              // ),
              // Consumer(
              //   builder: (context, ref, child) {
              //     final language = ref.watch(appLanguageProvider);

              //     return ExpandableCell(
              //       title: context.l10n.language,
              //       subtitle: language.title,
              //       count: 2,
              //       icon: "assets/icons/svg/ic_profile_lang.svg",
              //       content: const LanguagePicker(),
              //     );
              //   },
              // ),
              // const SizedBox(
              //   height: 16,
              // ),
              // const DarkModeCell(),
              // const SizedBox(
              //   height: 16,
              // ),
              // ExpandableCell(
              //   title: context.l10n.aboutApp,
              //   count: 1,
              //   icon: "assets/icons/svg/ic_profile_about.svg",
              //   content: const SizedBox(
              //     height: 100,
              //   ),
              // ),
              // const SizedBox(
              //   height: 16,
              // ),
              // Consumer(
              //   builder: (context, ref, child) => LogoutCell(
              //     onTap: ref.read(authProvider.notifier).logOut,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthorizedRow extends StatelessWidget {
  const AuthorizedRow({super.key, required this.userData});

  final SsoUserInfo userData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFF5F7FA),
        child: InkWell(
          onTap: () {
            const ProfileInfoPageRoute().push(context);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                const SizedBox(
                  width: 16.0,
                ),
                SvgPicture.asset(
                  'assets/icons/svg/ic_chevron_left.svg',
                  height: 24,
                  width: 24,
                  package: PackageConfig.packageName,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF1E2A36),
                    BlendMode.srcIn,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        userData.getFirstAndLastName(),
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .textM
                            .copyWith(color: const Color(0xFF1E2A36)),
                      ),
                      Text(
                        userData.idNo ?? "",
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .textS
                            .copyWith(color: const Color(0x5C1E2A36)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 12.0,
                ),
                const ProfileImageWidget(
                  editable: false,
                  dimension: 36,
                ),
                const SizedBox(
                  width: 16.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
