import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/features/_shared_features/notifications_cell/widgets/notifications_setting_cell_mapness.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/profile/authorized_widget.dart';
import 'package:mapness/widgets/profile/logout_dialog.dart';
import 'package:mapness/widgets/profile/unathorized_profile.dart';

final InAppReview inAppReview = InAppReview.instance;

@RoutePage()
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    final actionIcon = SystemIcons.arrowCornerRightLarge.icon(
      color: context.colorsV3.foregroundMuted,
    );
    final trailing = ContentRowTextTrailingOptions(
      icon: SystemIcons.arrowCornerRightLarge,
      iconColor: context.colorsV3.foregroundMuted,
    );
    final Widget Function(IconData icon) leadingIconBuilder = (icon) => Icon(
          icon,
          color: context.colorsV3.accentDefault,
          size: 24,
        );
    final userData = ref.watch(authProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Material(
        color: context.colorsV3.staticDarkblue,
        child: SafeArea(
          bottom: false,
          child: Directionality(
            textDirection: textDirection,
            child: Stack(
              children: [
                CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 20),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.$4x,
                        ),
                        child: userData.maybeWhen(
                          orElse: () => UnauthorizedProfile(
                            onConnect: ref.read(authProvider.notifier).doAuth,
                          ),
                          data: (userData) => userData == null
                              ? UnauthorizedProfile(
                                  onConnect: ref.read(authProvider.notifier).doAuth,
                                )
                              : AuthorizedWidget(
                                  userData: userData,
                                ),
                        ),
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.colorsV3.backgroundSurface4,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(RadiusBorder.xxl),
                            topRight: Radius.circular(RadiusBorder.xxl),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.$4x,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: Spacing.$4x),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(RadiusBorder.l),
                              child: ContentWrapper(
                                color: context.colorsV3.backgroundSurface1,
                                children: [
                                  userData.maybeWhen(
                                    orElse: () => const SizedBox.shrink(),
                                    data: (data) => data == null
                                        ? const SizedBox.shrink()
                                        : ContentRowV2(
                                            onTap: () => context.router.push(const ProfileInfoRoute()),
                                            trailing: trailing,
                                            leading: leadingIconBuilder(GeneralIcons.user),
                                            text: ContentRowTextOptions(
                                              title: context.l10n.personalData,
                                            ),
                                          ),
                                  ),
                                  ContentRowV2(
                                    onTap: () => context.router.push(const SettingsRoute()),
                                    trailing: trailing,
                                    leading: leadingIconBuilder(SystemIcons.settings),
                                    text: ContentRowTextOptions(
                                      title: context.l10n.settings,
                                    ),
                                  ),
                                  userData.maybeWhen(
                                    orElse: () => const SizedBox.shrink(),
                                    data: (data) => data == null
                                        ? const SizedBox.shrink()
                                        : NotificationsSettingsRow(actionIcon: actionIcon),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: Spacing.$4x),
                            ContentWrapper(
                              color: context.colorsV3.backgroundSurface1,
                              children: [
                                ContentRowV2(
                                  isDividerEnabled: true,
                                  onTap: () => context.router.push(const HelpCenterRoute()),
                                  trailing: trailing,
                                  leading: leadingIconBuilder(GeneralIcons.questionCircle),
                                  text: ContentRowTextOptions(
                                    title: context.l10n.helpCenter,
                                  ),
                                ),
                                ContentRowV2(
                                  isDividerEnabled: true,
                                  onTap: () {
                                    context.router.push(const AboutBaladyRoute());
                                  },
                                  trailing: trailing,
                                  leading: leadingIconBuilder(GeneralIcons.infoCircle),
                                  text: ContentRowTextOptions(
                                    title: context.l10n.aboutApp,
                                  ),
                                ),
                                ContentRowV2(
                                  onTap: () {
                                    inAppReview.openStoreListing(
                                      appStoreId: MapnessConstants.appStoreId,
                                    );
                                  },
                                  trailing: trailing,
                                  leading: leadingIconBuilder(GeneralIcons.star),
                                  text: ContentRowTextOptions(
                                    title: context.l10n.rateBaladyApp,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: Spacing.$4x),
                            userData.maybeWhen(
                              orElse: () => const SizedBox.shrink(),
                              data: (data) => data == null
                                  ? const SizedBox.shrink()
                                  : ContentWrapper(
                                      color: context.colorsV3.backgroundSurface1,
                                      children: [
                                        ContentRowV2(
                                          onTap: () => _logOut(context, ref),
                                          text: ContentRowTextOptions(
                                            title: context.l10n.logOut,
                                            titleOptions: ContentRowTextOption(
                                              baseColor: context.colorsV3.errorDefault,
                                            ),
                                          ),
                                          leading: SvgPicture.asset(
                                            'assets/icons/svg/ic_profile_logout.svg',
                                            height: 24,
                                            width: 24,
                                            matchTextDirection: true,
                                            package: PackageConfig.packageName,
                                            colorFilter: ColorFilter.mode(
                                              context.colorsV3.errorDefault,
                                              BlendMode.srcIn,
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
                  ],
                ),
                if (loading)
                  Center(
                    child: CircularProgressIndicator(
                      color: context.colorsV3.accentDefault,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _logOut(BuildContext context, WidgetRef ref) async {
    await showDialog(
      context: context,
      builder: (ctx) => LogoutDialog(
        onCancel: () => Navigator.of(ctx).pop(),
        onLogout: () async {
          if (!context.mounted) {
            return;
          }
          setState(() {
            loading = true;
          });
          Navigator.of(ctx).pop();
          await ref.read(authProvider.notifier).logOut();
          setState(() {
            loading = false;
          });
          // TODO(Scroollocker): Fix close browser window after logout after new flutter_appauth version upgraded
          Navigator.of(ctx).pop();
        },
        title: context.l10n.areYouSureYouWantToLogOutOfYourAccount,
        logOutText: context.l10n.logOut,
        cancelText: context.l10n.cancel,
      ),
    );
  }
}
