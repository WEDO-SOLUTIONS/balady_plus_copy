import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/constants/constants.dart';
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
      iconColor: context.colorsV3.foregroundMuted,
    );
    final Widget Function(IconData icon) leadingIconBuilder = (icon) => Icon(
          icon,
          color: context.colorsV3.accentDefault,
          size: 24,
        );
    final userData = ref.watch(authProvider);
    final isAuth = userData.valueOrNull != null;
    final backgroundColor = isAuth ? context.colorsV3.staticWhite : context.colorsV3.staticDarkblue;

    final overlay = switch (ThemeData.estimateBrightnessForColor(backgroundColor)) {
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
                        color: context.colorsV3.backgroundSurface4,
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
                                  borderRadius: BorderRadius.circular(RadiusBorder.l),
                                  child: ContentWrapper(
                                    color: context.colorsV3.backgroundSurface1,
                                    children: [
                                      if (isAuth)
                                        ContentRowV2(
                                          isDividerEnabled: true,
                                          onTap: () => context.router.push(const ProfileInfoRoute()),
                                          trailing: trailing,
                                          leading: leadingIconBuilder(GeneralIcons.userCircle),
                                          text: ContentRowTextOptions(
                                            title: context.l10n.account,
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
                                            'assets/icons/svg/percent.svg',
                                            package: PackageConfig.packageName,
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
                                      leading: leadingIconBuilder(GeneralIcons.infoSquare),
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
                                              onTap: () => _logOut(context, ref, isLoading),
                                              text: ContentRowTextOptions(
                                                title: context.l10n.signOut,
                                                titleOptions: ContentRowTextOption(
                                                  baseColor: context.colorsV3.errorDefault,
                                                ),
                                              ),
                                              leading: Icon(
                                                GeneralIcons.doorEntrance,
                                                size: AppSizes.xxs,
                                                color: context.colorsV3.errorDefault,
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
                  ],
                ),
                if (isLoading.value)
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

  Future<void> _logOut(BuildContext context, WidgetRef ref, ValueNotifier isLoading) async {
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
