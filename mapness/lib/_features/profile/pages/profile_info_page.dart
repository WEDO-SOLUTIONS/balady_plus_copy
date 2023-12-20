import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/profile/widgets/personal_data.dart';
import 'package:mapness/_features/profile/widgets/profile_image_widget.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class ProfileInfoPage extends ConsumerWidget {
  const ProfileInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(authProvider).requireValue!;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Directionality(
        textDirection: TextDirection.ltr,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 40,
                      ),
                      const Spacer(),
                      Text(
                        context.l10n.profileSettings,
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .accentM
                            .copyWith(color: const Color(0xFF1E2A36)),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Material(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFFF5F7FA),
                          child: InkWell(
                            onTap: () {
                              context.pop();
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: SvgPicture.asset(
                                'assets/icons/svg/ic_chevron_right.svg',
                                height: 24,
                                width: 24,
                                package: PackageConfig.packageName,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF1E2A36),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const ProfileImageWidget(
                      editable: true,
                      dimension: 96,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      userData.getFirstAndLastName(),
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .headingS
                          .copyWith(color: const Color(0xFF1E2A36)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      userData.idNo ?? "",
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .textS
                          .copyWith(
                            color: const Color(0xA31E2A36),
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              PersonalData(userInfo: userData),
              Padding(
                padding: const EdgeInsets.all(16.0),
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
                        color: const Color(0xff566B83).withOpacity(.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(context.l10n.logOut,
                              style: Theme.of(context)
                                  .extension<ThemeTextStyles>()!
                                  .textS
                                  .copyWith(
                                    color: const Color(0xffE0373D),
                                  )),
                          SvgPicture.asset(
                            "assets/icons/svg/ic_profile_logout.svg",
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
