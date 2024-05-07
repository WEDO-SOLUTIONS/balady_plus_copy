import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/profile/domain/user_profile_data.dart';
import 'package:mapness/_features/profile/widgets/personal_data.dart';
import 'package:mapness/_features/profile/widgets/profile_image_widget.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';

class ProfileInfoPage extends ConsumerWidget {
  const ProfileInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(authProvider).requireValue!;
    final direction = ref.watch(uiDirectionProvider);
    final language = ref.read(appLanguageProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Directionality(
        textDirection: Directionality.of(context),
        child: Material(
          color: Colors.white,
          child: ListView(
            children: [
              const SizedBox(
                width: 12,
              ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Material(
                          borderRadius: BorderRadius.circular(8),
                          color: context.color.surfaceBaseSecondary,
                          child: InkWell(
                            onTap: () {
                              context.pop();
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: SvgPicture.asset(
                                direction == TextDirection.ltr
                                    ? 'assets/icons/svg/ic_chevron_left.svg'
                                    : 'assets/icons/svg/ic_chevron_right.svg',
                                height: 24,
                                width: 24,
                                package: PackageConfig.packageName,
                                colorFilter: ColorFilter.mode(
                                  context.color.textAndIconsBasePrimary,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        context.l10n.profileSettings,
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .callout
                            .copyWith(color: context.color.textAndIconsBasePrimary),
                      ),
                      const Spacer(),
                      const SizedBox(
                        width: 40,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const ProfileImageWidget(
                      editable: true,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      userData.getLocalizedFirstAndLastName(language),
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .heading1
                          .copyWith(color: context.color.textAndIconsBasePrimary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      userData.idNo ?? '',
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!.footNote.copyWith(
                            color: NonThemeColor.color39,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              PersonalData(userInfo: userData),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Directionality(
                  textDirection: Directionality.of(context),
                  child: InkWell(
                    onTap: () async {
                      await ref.read(authProvider.notifier).logOut();
                      context.pop();
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: NonThemeColor.color27.withOpacity(.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(context.l10n.logOut,
                              style: Theme.of(context)
                                  .extension<ThemeTextStyles>()!.footNote.copyWith(
                                  color: context.color.textAndIconsStatusNegative,
                                ),),
                          SvgPicture.asset(
                            'assets/icons/svg/ic_profile_logout.svg',
                            height: 24,
                            width: 24,
                            package: PackageConfig.packageName,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
