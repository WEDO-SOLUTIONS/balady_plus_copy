import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/profile/widgets/authorized_profile.dart';
import 'package:mapness/_features/profile/widgets/dark_mode_cell.dart';
import 'package:mapness/_features/profile/widgets/expandable_cell.dart';
import 'package:mapness/_features/profile/widgets/language_picker.dart';
import 'package:mapness/_features/profile/widgets/logout_cell.dart';
import 'package:mapness/_features/profile/widgets/personal_data.dart';
import 'package:mapness/_features/profile/widgets/profile_header.dart';
import 'package:mapness/_features/profile/widgets/unathorized_profile.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Material(
          color: const Color(0xFFF4F4F5),
          child: ListView(
            children: [
              const SafeArea(
                bottom: false,
                child: ProfileHeader(),
              ),
              const SizedBox(
                height: 6,
              ),
              Consumer(
                builder: (context, ref, child) {
                  final userData = ref.watch(authProvider);

                  return userData == null
                      ? UnautorizedProfile(
                          onConnect: ref.read(authProvider.notifier).doAuth,
                        )
                      : AuthorizedProfile(
                          userData: userData,
                        );
                },
              ),
              Consumer(
                builder: (context, ref, child) {
                  final userData = ref.watch(authProvider);

                  return userData == null
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: ExpandableCell(
                            title: context.l10n.personalData,
                            count: 7,
                            icon: "assets/icons/svg/ic_profile_data.svg",
                            content: PersonalData(
                              userInfo: userData,
                            ),
                          ),
                        );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Consumer(
                builder: (context, ref, child) {
                  final language = ref.watch(appLanguageProvider);

                  return ExpandableCell(
                    title: context.l10n.language,
                    subtitle: language.title,
                    count: 2,
                    icon: "assets/icons/svg/ic_profile_lang.svg",
                    content: const LanguagePicker(),
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              const DarkModeCell(),
              const SizedBox(
                height: 16,
              ),
              ExpandableCell(
                title: context.l10n.aboutApp,
                count: 1,
                icon: "assets/icons/svg/ic_profile_about.svg",
                content: const SizedBox(
                  height: 100,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const LogoutCell(),
            ],
          ),
        ),
      ),
    );
  }
}
