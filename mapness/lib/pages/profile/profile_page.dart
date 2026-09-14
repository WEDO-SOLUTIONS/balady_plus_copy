import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/services/local/shared_prefs_manager.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/app/features/delegators/domain/entities/agent_entity.dart';
import 'package:balady_plus/app/features/delegators/domain/entities/delegator_entity.dart';
import 'package:balady_plus/app/features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
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
    final Widget Function(IconData icon) leadingIconBuilder = (icon) =>
        Icon(icon, color: context.colors.accentDefault, size: 24);
    final userData = ref.watch(authProvider);
    final isAuth = userData.value != null;
    final isDGA =
        context.read<ThemeController>().currentTheme == BaladyAppThemes.darkDGA ||
        context.read<ThemeController>().currentTheme == BaladyAppThemes.lightDGA;
    final activeEvent = ref.watch(activeCityEventProvider);
    final isFoundingDay = activeEvent == CityEventType.foundingDay;
    final backgroundColor = isAuth
        ? context.colors.backgroundSurface1
        : isFoundingDay
        ? context.colors.accentDefault
        : isDGA
        ? context.colors.accentDefault
        : context.colorsV3.staticDarkblue;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.read<ThemeController>().systemOverlayStyle,
      child: Scaffold(
        backgroundColor: context.colors.accentDefault,
        body: SafeArea(
          bottom: false,
          child: Directionality(
            textDirection: textDirection,
            child: Stack(
              children: [
                CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
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
                          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              const SizedBox(height: Spacing.$4x),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(RadiusBorder.l),
                                child: ContentWrapper(
                                  color: isDGA ? context.colors.accentSecondarySoft : context.colors.backgroundSurface1,
                                  children: [
                                    userData.maybeWhen(
                                      orElse: () => const SizedBox.shrink(),
                                      data: (data) => data == null
                                          ? const SizedBox.shrink()
                                          : Column(
                                              children: [
                                                ContentRow(
                                                  isDividerEnabled: true,
                                                  onTap: () => context.router.push(const ProfileInfoRoute()),
                                                  trailing: trailing,
                                                  leading: leadingIconBuilder(GeneralIcons.userCircle),
                                                  text: ContentRowTextOptions(title: context.l10n.account),
                                                ),
                                                if (CommonProperties.isLoggedInMunicipality)
                                                  ContentRowV2(
                                                    isDividerEnabled: true,
                                                    onTap: () => CommonFunctions.openVolunteerProfileScreen(),
                                                    trailing: trailing,
                                                    leading: leadingIconBuilder(Icons.favorite),
                                                    text: ContentRowTextOptions(title: 'volunteer_info'.tr()),
                                                  )
                                                else
                                                  const SizedBox.shrink(),
                                              ],
                                            ),
                                    ),
                                    ContentRowV2(
                                      onTap: () => context.router.push(const SettingsRoute()),
                                      trailing: trailing,
                                      leading: leadingIconBuilder(SystemIcons.settings),
                                      text: ContentRowTextOptions(title: context.l10n.settings),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: Spacing.$4x),
                              ContentWrapper(
                                color: isDGA ? context.colors.accentSecondarySoft : context.colors.backgroundSurface1,
                                children: [
                                  ContentRowV2(
                                    isDividerEnabled: true,
                                    onTap: () => context.router.push(const HelpCenterRoute()),
                                    trailing: trailing,
                                    leading: leadingIconBuilder(GeneralIcons.questionCircle),
                                    text: ContentRowTextOptions(title: context.l10n.helpCenter),
                                  ),
                                  ContentRowV2(
                                    isDividerEnabled: true,
                                    onTap: () {
                                      context.router.push(const AboutBaladyRoute());
                                    },
                                    trailing: trailing,
                                    leading: leadingIconBuilder(GeneralIcons.infoSquare),
                                    text: ContentRowTextOptions(title: context.l10n.aboutApp),
                                  ),
                                  ContentRowV2(
                                    onTap: () {
                                      context.router.push(const PrivacyAndTermsOfUseRoute());
                                    },
                                    trailing: trailing,
                                    leading: Padding(
                                      padding: const EdgeInsetsGeometry.directional(start: 2),
                                      child: SvgPicture.asset(
                                        'assets/icons/svg/shield-lock.svg',
                                        color: context.colors.accentDefault,
                                      ),
                                    ),
                                    text: ContentRowTextOptions(title: 'privacyAndTermsTitle'.tr()),
                                  ),
                                ],
                              ),
                              const SizedBox(height: Spacing.$4x),
                              userData.maybeWhen(
                                orElse: () => const SizedBox.shrink(),
                                data: (data) => data == null
                                    ? const SizedBox.shrink()
                                    : ContentWrapper(
                                        color: isDGA
                                            ? context.colors.accentSecondarySoft
                                            : context.colors.backgroundSurface1,
                                        children: [
                                          ContentRowV2(
                                            backgroundColor: isDGA
                                                ? context.colors.accentSecondarySoft
                                                : context.colors.backgroundSurface1,
                                            onTap: () => _logOut(context, ref, isLoading),
                                            text: ContentRowTextOptions(
                                              title: context.l10n.signOut,
                                              titleOptions: ContentRowTextOption(
                                                baseColor: context.colors.errorDefault,
                                              ),
                                            ),
                                            leading: Icon(
                                              GeneralIcons.doorEntrance,
                                              size: AppSizes.xxs,
                                              color: context.colors.errorDefault,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (isLoading.value) Center(child: CircularProgressIndicator(color: context.colors.accentDefault)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _logOut(BuildContext context, WidgetRef ref, ValueNotifier isLoading) async {
    final shouldLogout = await context.router.root.push<bool>(const ProfileLogoutSheetRoute());
    if (shouldLogout != true || !context.mounted) {
      return;
    }
    isLoading.value = true;
    try {
      await ref.read(authProvider.notifier).logOut();
    } catch (exception) {
      logger.log('Error logging out: $exception', logLevel: MapnessLogLevel.error);
    } finally {
      isLoading.value = false;
    }
  }
}
