import 'package:balady_uikit/balady_uikit.dart';
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
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/widgets/profile/authorized_widget.dart';
import 'package:mapness/widgets/profile/language_picker.dart';
import 'package:mapness/widgets/profile/logout_dialog.dart';
import 'package:mapness/widgets/profile/unathorized_profile.dart';

final InAppReview inAppReview = InAppReview.instance;

class ProfilePage extends ConsumerWidget {
  // According to task BALADY-416 to hide flags we temporary hide it with boolean flag
  // We don't delete it because this goes against the design of this feature
  static const showFlags = false;

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textDirection = Directionality.of(context);
    final actionIcon = context.isLTR
        ? SystemIcons.arrowCornerRightS.icon(
            color: context.color.textAndIconsBaseSecondary,
          )
        : SystemIcons.arrowCornerLeftS.icon(
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
                              ContentRow(
                                options: ContentRowOptions(
                                  actionWidget: ContentRowActionOptions(
                                    actionIcon: actionIcon,
                                  ),
                                  leadingIcon: Icon(
                                    GeneralIcons.settings,
                                    color: context.color.textAndIconsStatusAccent,
                                  ),
                                  title: context.l10n.settings,
                                ),
                                onTap: () => const SettingsRoute().push(context),
                              ),
                              ContentRow(
                                options: ContentRowOptions(
                                  actionWidget: ContentRowActionOptions(
                                    actionIcon: actionIcon,
                                  ),
                                  leadingIcon: Icon(
                                    GeneralIcons.questionCircleLTR,
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
                                    GeneralIcons.infoCircleFill,
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
                                    GeneralIcons.starSolid,
                                    color: context.color.textAndIconsStatusAccent,
                                  ),
                                  title: context.l10n.rateBaladyApp,
                                ),
                                onTap: () {
                                  inAppReview.openStoreListing(
                                    appStoreId: MapnessConsts.appStoreId,
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: Spacing.verticalPaddingInsideWrapper,
                          ),
                          Consumer(
                            builder: (context, ref, child) {
                              final language = ref.watch(appLanguageProvider);
                              return ContentWrapper(
                                color: context.color.surfaceBaseSecondary,
                                children: [
                                  ContentRowExpandable(
                                    options: ContentRowOptions(
                                      title: context.l10n.language,
                                      subtitle: language.title,
                                      leadingIcon: leadingIcon(language),
                                    ),
                                    content: const LanguagePicker(),
                                    expandIconColor: context.color.textAndIconsBaseSecondary,
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(
                            height: Spacing.verticalGapBetweenChips,
                          ),
                          Text(
                            context.l10n.chooseTheLanguageOfAll,
                            style: context.textStyle.caption.copyWith(
                              color: context.color.textAndIconsBaseTertiary,
                            ),
                          ),
                          const SizedBox(
                            height: Spacing.verticalPaddingInsideWrapper,
                          ),
                          ContentWrapper(
                            color: context.color.surfaceBaseSecondary,
                            children: [
                              ContentRow(
                                options: ContentRowOptions(
                                    leadingIcon: AppIcons(
                                      iconData: GeneralIcons.darkMode,
                                      color: context.color.textAndIconsStatusAccent,
                                      size: 24,
                                    ),
                                    title: context.l10n.darkMap,
                                    actionWidget: ContentRowActionOptions(
                                      enabledToggle: true,
                                      toggleInitialValue: ref.watch(darkModeProvider),
                                    )),
                                onToggle: (_) {
                                  ref.read(darkModeProvider.notifier).toggle();
                                },
                              )
                            ],
                          ),
                          const SizedBox(
                            height: Spacing.verticalGapBetweenChips,
                          ),
                          Text(
                            context.l10n.changeTheColorSchemeOfAnApp,
                            style: context.textStyle.caption.copyWith(
                              color: const Color(0xFF1E2A36).withOpacity(0.36),
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Consumer(builder: (context, ref, _) {
                            final userData = ref.watch(authProvider);
                            const emptyBox = SizedBox.shrink();

                            return userData.maybeWhen(
                              orElse: () => emptyBox,
                              data: (data) => data == null
                                  ? emptyBox
                                  : SizedBox(
                                      width: double.infinity,
                                      child: AppButton(
                                        primaryLabel: context.l10n.logOut,
                                        buttonColorScheme: ButtonColorScheme.tertiary,
                                        onTap: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (ctx) => LogoutDialog(
                                              onCancel: () => Navigator.of(ctx).pop(),
                                              onLogout: () async {
                                                await ref.read(authProvider.notifier).logOut();
                                                context.pop();
                                              },
                                              title: context.l10n.areYouSureYouWantToLogOutOfYourAccount,
                                              logOutText: context.l10n.logOut,
                                              cancelText: context.l10n.cancel,
                                            ),
                                          );
                                        },
                                        textColor: context.color.textAndIconsStatusNegative,
                                        trailing: SvgPicture.asset(
                                          'assets/icons/svg/ic_profile_logout.svg',
                                          height: 24,
                                          width: 24,
                                          matchTextDirection: true,
                                          package: PackageConfig.packageName,
                                        ),
                                      ),
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

  Widget? leadingIcon(Language language) => showFlags
      ? SvgPicture.asset(
          switch (language) {
            Language.arabic => 'assets/icons/svg/sa_flag.svg',
            Language.english => 'assets/icons/svg/uk_flag.svg',
          },
          height: 16,
          width: 22,
          package: PackageConfig.packageName,
        )
      : null;
}
