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
      color: context.color.textAndIconsBaseSecondary,
    );
    final userData = ref.watch(authProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Material(
        color: Colors.white,
        child: SafeArea(
          child: Directionality(
            textDirection: textDirection,
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.$4x,
                        ),
                        child: userData.maybeWhen(
                          orElse: () => UnautorizedProfile(
                            onConnect: ref.read(authProvider.notifier).doAuth,
                          ),
                          data: (userData) => userData == null
                              ? UnautorizedProfile(
                                  onConnect: ref.read(authProvider.notifier).doAuth,
                                )
                              : AuthorizedWidget(
                                  userData: userData,
                                ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.$4x,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: Spacing.$4x),
                            ContentWrapper(
                              color: context.color.surfaceBaseSecondary,
                              children: [
                                userData.maybeWhen(
                                  orElse: () => const SizedBox.shrink(),
                                  data: (data) => data == null
                                      ? const SizedBox.shrink()
                                      : ContentRow(
                                          options: ContentRowOptions(
                                            actionWidget: ContentRowActionOptions(
                                              actionIcon: actionIcon,
                                            ),
                                            leadingIcon: Icon(
                                              GeneralIcons.user,
                                              color: context.color.textAndIconsStatusAccent,
                                            ),
                                            title: context.l10n.personalData,
                                          ),
                                          onTap: () => context.router.push(const ProfileInfoRoute()),
                                        ),
                                ),
                                ContentRow(
                                  options: ContentRowOptions(
                                    actionWidget: ContentRowActionOptions(
                                      actionIcon: actionIcon,
                                    ),
                                    leadingIcon: Icon(
                                      SystemIcons.settings,
                                      color: context.color.textAndIconsStatusAccent,
                                    ),
                                    title: context.l10n.settings,
                                  ),
                                  onTap: () => context.router.push(const SettingsRoute()),
                                ),
                                userData.maybeWhen(
                                  orElse: () => const SizedBox.shrink(),
                                  data: (data) => data == null
                                      ? const SizedBox.shrink()
                                      : NotificationsSettingsRow(actionIcon: actionIcon),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: Spacing.$4x,
                            ),
                            ContentWrapper(
                              color: context.color.surfaceBaseSecondary,
                              children: [
                                ContentRow(
                                  options: ContentRowOptions(
                                    actionWidget: ContentRowActionOptions(
                                      actionIcon: actionIcon,
                                    ),
                                    leadingIcon: Icon(
                                      GeneralIcons.questionCircle,
                                      color: context.color.textAndIconsStatusAccent,
                                    ),
                                    title: context.l10n.helpCenter,
                                  ),
                                  onTap: () => context.router.push(const HelpCenterRoute()),
                                ),
                                ContentRow(
                                  options: ContentRowOptions(
                                    actionWidget: ContentRowActionOptions(
                                      actionIcon: actionIcon,
                                    ),
                                    leadingIcon: Icon(
                                      GeneralIcons.infoCircle,
                                      color: context.color.textAndIconsStatusAccent,
                                    ),
                                    title: context.l10n.aboutApp,
                                  ),
                                  onTap: () {
                                    context.router.push(const AboutBaladyRoute());
                                  },
                                ),
                                ContentRow(
                                  options: ContentRowOptions(
                                    actionWidget: ContentRowActionOptions(
                                      actionIcon: actionIcon,
                                    ),
                                    leadingIcon: Icon(
                                      GeneralIcons.star,
                                      color: context.color.textAndIconsStatusAccent,
                                    ),
                                    title: context.l10n.rateBaladyApp,
                                  ),
                                  onTap: () {
                                    inAppReview.openStoreListing(
                                      appStoreId: MapnessConstants.appStoreId,
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: Spacing.$4x,
                            ),
                            userData.maybeWhen(
                              orElse: () => const SizedBox.shrink(),
                              data: (data) => data == null
                                  ? const SizedBox.shrink()
                                  : ContentWrapper(
                                      color: context.color.surfaceBaseSecondary,
                                      children: [
                                        ContentRow(
                                          onTap: () => _logOut(context, ref),
                                          options: ContentRowOptions(
                                            titleStyle: context.textStyle.text
                                                .copyWith(color: context.color.textAndIconsStatusNegative),
                                            title: context.l10n.logOut,
                                            leadingIcon: SvgPicture.asset(
                                              'assets/icons/svg/ic_profile_logout.svg',
                                              height: 24,
                                              width: 24,
                                              matchTextDirection: true,
                                              package: PackageConfig.packageName,
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
                      color: context.color.textAndIconsStatusAccent,
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
