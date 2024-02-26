import 'package:balady_plus/app/features/entry_point/entry_point_exports.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/profile/domain/user_profile_data.dart';
import 'package:mapness/_features/profile/widgets/profile_header.dart';
import 'package:mapness/_features/profile/widgets/profile_image_widget.dart';
import 'package:mapness/_features/profile/widgets/unathorized_profile.dart';
import 'package:mapness/app/routes/profile.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_features.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:rate_my_app/rate_my_app.dart';

final InAppReview inAppReview = InAppReview.instance;

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rateMyApp = RateMyApp(
      minDays: 0, // Show rate popup on first day of install.
      minLaunches:
          5, // Show rate popup after 5 launches of app after minDays is passed.
    );
    return WillPopScope(
      onWillPop: () async {
        StatefulNavigationShell.of(context).goBranch(
          ref.read(appFeaturesProvider).naviEnabled ? 3 : 2,
        );
        return false;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Directionality(
          textDirection: Directionality.of(context),
          child: Material(
            color: Colors.white,
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              children: [
                SafeArea(
                  bottom: false,
                  child: ProfileHeader(
                    onBackPress: () {
                      StatefulNavigationShell.of(context).goBranch(
                        ref.read(appFeaturesProvider).naviEnabled ? 3 : 2,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
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
                _buildSettingsRow(
                  assetImage: 'assets/images_svg/profile_settings.svg',
                  text: context.l10n.settings,
                  onTap: () {
                    const SettingsRoute().push(context);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                _buildSettingsRow(
                  assetImage: 'assets/images_svg/profile_help.svg',
                  text: context.l10n.helpCenter,
                  onTap: () {
                    const HelpCenterRoute().push(context);
                  },
                ),
                _buildDivider(),
                _buildSettingsRow(
                  assetImage: 'assets/images_svg/profile_info.svg',
                  text: context.l10n.aboutApp,
                  onTap: () {
                    const AboutBaladyRoute().push(context);
                  },
                ),
                _buildDivider(),
                _buildSettingsRow(
                  assetImage: 'assets/images_svg/profile_star.svg',
                  text: context.l10n.rateBaladyApp,
                  onTap: () {
                    // rateMyApp.showRateDialog(
                    //   context,
                    //   title: context.l10n.rateThisApp,
                    //   message: context.l10n.rateMessage,
                    //   rateButton: context.l10n.rate,
                    //   noButton: context.l10n.noThanks,
                    //   laterButton: context.l10n.maybeLater,
                    //   listener: (button) {
                    //     switch (button) {
                    //       case RateMyAppDialogButton.rate:
                    //         break;
                    //       case RateMyAppDialogButton.later:
                    //         break;
                    //       case RateMyAppDialogButton.no:
                    //         break;
                    //     }

                    //     return true;
                    //   },
                    //   ignoreNativeDialog: Platform.isAndroid,
                    //   dialogStyle: const DialogStyle(),
                    //   onDismissed: () => rateMyApp
                    //       .callEvent(RateMyAppEventType.laterButtonPressed),
                    // );
                    inAppReview.openStoreListing(appStoreId: 'id1522185123');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            color: context.color.surface_base_secondary,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 52,
                left: 8,
              ),
              child: Divider(
                height: 1,
                color: context.color.text_and_icons_base_primary.withOpacity(0.2),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsRow({
    required String assetImage,
    required String text,
    VoidCallback? onTap,
  }) {
    return Consumer(
      builder: (context, ref, _) {
        final direction = ref.watch(uiDirectionProvider);

        return SizedBox(
          height: 52,
          child: Material(
            borderRadius: BorderRadius.circular(12),
            color: context.color.surface_base_secondary,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    SvgPicture.asset(
                      assetImage,
                      height: 24,
                      width: 24,
                      package: PackageConfig.packageName,
                      colorFilter: ColorFilter.mode(
                        context.color.text_and_icons_status_accent,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Text(
                        text,
                        textAlign: TextAlign.start,
                        textDirection: direction,
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .textM
                            .copyWith(color: context.color.text_and_icons_base_primary),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    SvgPicture.asset(
                      direction == TextDirection.rtl
                          ? 'assets/icons/svg/ic_chevron_left.svg'
                          : 'assets/icons/svg/ic_chevron_right.svg',
                      height: 24,
                      width: 24,
                      package: PackageConfig.packageName,
                      colorFilter: ColorFilter.mode(
                        context.color.text_and_icons_base_primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AuthorizedRow extends ConsumerWidget {
  const AuthorizedRow({required this.userData, super.key});

  final SsoUserInfo userData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.read(appLanguageProvider);

    return Material(
      borderRadius: BorderRadius.circular(12),
      color: context.color.surface_base_secondary,
      child: InkWell(
        onTap: () {
          const ProfileInfoPageRoute().push(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              const SizedBox(
                width: 16,
              ),
              const ProfileImageWidget(
                dimension: 36,
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData.getLocalizedFirstAndLastName(language),
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .textM
                          .copyWith(color: context.color.text_and_icons_base_primary),
                    ),
                    Text(
                      userData.idNo ?? '',
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .textS
                          .copyWith(color: context.color.text_and_icons_base_primary),
                    ),
                  ],
                ),
              ),
              Consumer(
                builder: (context, ref, _) {
                  return SvgPicture.asset(
                    ref.watch(uiDirectionProvider) == TextDirection.ltr
                        ? 'assets/icons/svg/ic_chevron_right.svg'
                        : 'assets/icons/svg/ic_chevron_left.svg',
                    height: 24,
                    width: 24,
                    package: PackageConfig.packageName,
                    colorFilter: ColorFilter.mode(
                      context.color.text_and_icons_base_primary,
                      BlendMode.srcIn,
                    ),
                  );
                },
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
