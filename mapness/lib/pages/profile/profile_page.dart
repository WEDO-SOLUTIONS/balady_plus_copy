import 'package:auto_route/auto_route.dart';
import 'package:balady_authorization/src/web/global/remote_config.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/profile/log_out_sheet.dart';
import 'package:mapness/widgets/profile/profile_header.dart';

final InAppReview inAppReview = InAppReview.instance;

@RoutePage()
class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final textDirection = Directionality.of(context);
    final trailing = ContentRowTextTrailingOptions(
      icon: SystemIcons.arrowCornerRightLarge,
      iconColor: context.colors.foregroundMuted,
    );
    final Widget Function(IconData icon) leadingIconBuilder = (icon) => Icon(
          icon,
          color: context.colors.accentDefault,
          size: 24,
        );
    final userData = ref.watch(authProvider);
    final isAuth = userData.valueOrNull != null;
    final backgroundColor = isAuth ? context.colorsV3.staticWhite : context.colorsV3.staticDarkblue;

    final overlay =
        switch (ThemeData.estimateBrightnessForColor(backgroundColor)) {
      Brightness.dark => SystemUiOverlayStyle.light,
      Brightness.light => SystemUiOverlayStyle.dark,
    };

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
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
                    const SliverToBoxAdapter(
                      child: SafeArea(
                        bottom: false,
                        right: false,
                        left: false,
                        child: ProfileHeader(),
                      ),
                    ),
                    DecoratedSliver(
                      decoration: BoxDecoration(
                        color: context.colors.backgroundSurface4,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(RadiusBorder.xxl),
                          topRight: Radius.circular(RadiusBorder.xxl),
                        ),
                      ),
                      sliver: SliverFillAfter(
                        sliver: SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.$4x,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                const SizedBox(height: Spacing.$4x),
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(RadiusBorder.l),
                                  child: ContentWrapper(
                                    color: context.colors.backgroundSurface1,
                                    children: [
                                      userData.maybeWhen(
                                        orElse: () => const SizedBox.shrink(),
                                        data: (data) => data == null
                                            ? const SizedBox.shrink()
                                            : Column(
                                                children: [
                                                  ContentRow(
                                                    isDividerEnabled: true,
                                                    onTap: () => context.router
                                                        .push(
                                                            const ProfileInfoRoute()),
                                                    trailing: trailing,
                                                    leading: leadingIconBuilder(
                                                        GeneralIcons
                                                            .userCircle),
                                                    text: ContentRowTextOptions(
                                                      title:
                                                          context.l10n.account,
                                                    ),
                                                  ),
                                                  if (CommonProperties.isLoggedInMunicipality) ContentRowV2(
                                                    isDividerEnabled: true,
                                                    onTap: () =>
                                                    CommonFunctions.openVolunteerProfileScreen(),

                                                    trailing: trailing,
                                                    leading: leadingIconBuilder(
                                                        Icons.favorite),
                                                    text: ContentRowTextOptions(
                                                      title:
                                                          'volunteer_info'.tr(),
                                                    ),
                                                  )else const SizedBox.shrink(),
                                                ],
                                              ),
                                      ),
                                      ContentRow(
                                        onTap: () => context.router
                                            .push(const SettingsRoute()),
                                        trailing: trailing,
                                        leading: leadingIconBuilder(
                                            SystemIcons.settings),
                                        text: ContentRowTextOptions(
                                          title: context.l10n.settings,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isAuth)
                                  Padding(
                                    padding: const EdgeInsets.only(top: Spacing.$4x),
                                    child: ContentWrapper(
                                      color: context.colorsV3.backgroundSurface1,
                                      children: [
                                        ContentRowV2(
                                          isDividerEnabled: true,
                                          onTap: () => context.router.push(const ProfilePreferencesRoute()),
                                          trailing: trailing,
                                          leading: SvgPicture.asset(
                                            Assets.icons.svg.percent.keyName,
                                          ),
                                          text: ContentRowTextOptions(
                                            title: context.l10n.preferences,
                                          ),
                                        ),
                                        ContentRowV2(
                                          onTap: () => context.router.push(const FavouriteOffersScreenViewRoute()),
                                          trailing: trailing,
                                          leading: leadingIconBuilder(GeneralIcons.heart),
                                          text: ContentRowTextOptions(
                                            title: context.l10n.favoriteOffers,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                const SizedBox(height: Spacing.$4x),
                                ContentWrapper(
                                  color: context.colors.backgroundSurface1,
                                  children: [
                                    ContentRow(
                                      isDividerEnabled: true,
                                      onTap: () => context.router
                                          .push(const HelpCenterRoute()),
                                      trailing: trailing,
                                      leading: leadingIconBuilder(
                                          GeneralIcons.questionCircle),
                                      text: ContentRowTextOptions(
                                        title: context.l10n.helpCenter,
                                      ),
                                    ),
                                    ContentRow(
                                      onTap: () {
                                        context.router
                                            .push(const AboutBaladyRoute());
                                      },
                                      trailing: trailing,
                                      leading: leadingIconBuilder(
                                          GeneralIcons.infoSquare),
                                      text: ContentRowTextOptions(
                                        title: context.l10n.aboutApp,
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
                                          color: context
                                              .colorsV3.backgroundSurface1,
                                          children: [
                                            ContentRowV2(
                                              onTap: () => _logOut(
                                                  context, ref, isLoading),
                                              text: ContentRowTextOptions(
                                                title: context.l10n.signOut,
                                                titleOptions:
                                                    ContentRowTextOption(
                                                  baseColor: context
                                                      .colorsV3.errorDefault,
                                                ),
                                              ),
                                              leading: Icon(
                                                GeneralIcons.doorEntrance,
                                                size: AppSizes.xxs,
                                                color: context
                                                    .colorsV3.errorDefault,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                                const SizedBox(height: Spacing.$16x),
                                InkWell(
                                  onTap: () => CommonFunctions.openBaladyWebView(
                                      "${BaladyAuthorizationRemoteConfig.baladyWebsite}${"locale".tr()}/privacy-policy",
                                      needLogin: false,
                                    ),
                                  child: Text(
                                    'privacy_policy'.tr(),
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (isLoading.value)
                  Center(
                    child: CircularProgressIndicator(
                      color: context.colors.accentDefault,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _logOut(
      BuildContext context, WidgetRef ref, ValueNotifier isLoading) async {
    await showDialog(
      context: context,
      builder: (ctx) => LogoutSheet(
        title: context.l10n.signOut,
        description: context.l10n.signOutDescription,
        buttonText: context.l10n.signOutSwipe,
        onLogout: () async {
          if (!context.mounted) {
            return;
          }
          isLoading.value = true;

          Navigator.of(ctx).pop();
          await ref.read(authProvider.notifier).logOut();
          isLoading.value = false;
        },
      ),
    );
  }
}
