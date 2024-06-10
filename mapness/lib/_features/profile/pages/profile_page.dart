import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mapness/app/routes/profile.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_features.dart';
import 'package:mapness/widgets/profile/authorized_widget.dart';
import 'package:mapness/widgets/profile/logout_dialog.dart';
import 'package:mapness/widgets/profile/unathorized_profile.dart';

final InAppReview inAppReview = InAppReview.instance;

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textDirection = Directionality.of(context);
    final actionIcon = context.isLTR
        ? SystemIcons.arrowCornerRightSmall.icon(
            color: context.color.textAndIconsBaseSecondary,
          )
        : SystemIcons.arrowCornerLeftSmall.icon(
            color: context.color.textAndIconsBaseSecondary,
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
        child: Material(
          color: Colors.white,
          child: SafeArea(
            child: Directionality(
              textDirection: textDirection,
              child: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 20,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.horizontalPaddingInsideWrapper,
                      ),
                      child: Consumer(
                        builder: (context, ref, child) {
                          final userUnauthorized = UnautorizedProfile(
                            onConnect: ref.read(authProvider.notifier).doAuth,
                          );
                          final userData = ref.watch(authProvider);
                          return userData.maybeWhen(
                            orElse: () => userUnauthorized,
                            data: (userData) => userData == null
                                ? userUnauthorized
                                : AuthorizedWidget(
                                    userData: userData,
                                  ),
                          );
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.horizontalPaddingInsideWrapper,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: Spacing.verticalPaddingInsideWrapper,
                          ),
                          ContentWrapper(
                            color: context.color.surfaceBaseSecondary,
                            children: [
                              Consumer(builder: (context, ref, child) {
                                final userData = ref.watch(authProvider);

                                return userData.maybeWhen(
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
                                          onTap: () => const ProfileInfoPageRoute().push(context),
                                        ),
                                );
                              }),
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
                                onTap: () => const SettingsRoute().push(context),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: Spacing.verticalPaddingInsideWrapper,
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
                                onTap: () => const HelpCenterRoute().push(context),
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
                                  const AboutBaladyRoute().push(context);
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
                            height: Spacing.verticalPaddingInsideWrapper,
                          ),
                          Consumer(builder: (context, ref, _) {
                            final userData = ref.watch(authProvider);
                            const emptyBox = SizedBox.shrink();

                            return userData.maybeWhen(
                              orElse: () => emptyBox,
                              data: (data) => data == null
                                  ? emptyBox
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
                            );
                          })
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
          await ref.read(authProvider.notifier).logOut();
          context.pop();
        },
        title: context.l10n.areYouSureYouWantToLogOutOfYourAccount,
        logOutText: context.l10n.logOut,
        cancelText: context.l10n.cancel,
      ),
    );
  }
}
