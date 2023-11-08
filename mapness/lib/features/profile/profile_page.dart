import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/common/providers/app_language.dart';
import 'package:mapness/features/common/providers/user_state.dart';
import 'package:mapness/features/profile/widgets/authorized_profile.dart';
import 'package:mapness/features/profile/widgets/dark_mode_cell.dart';
import 'package:mapness/features/profile/widgets/expandable_cell.dart';
import 'package:mapness/features/profile/widgets/language_picker.dart';
import 'package:mapness/features/profile/widgets/logout_cell.dart';
import 'package:mapness/features/profile/widgets/personal_data.dart';
import 'package:mapness/features/profile/widgets/profile_header.dart';
import 'package:mapness/features/profile/widgets/unathorized_profile.dart';
import 'package:mapness/features/profile/widgets/user_state_picker.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
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
            Consumer(builder: (context, ref, child) {
              final userState = ref.watch(userStateProvider);

              return userState == UserState.guest
                  ? const UnautorizedProfile()
                  : const AuthorizedProfile();
            }),
            const SizedBox(
              height: 16,
            ),
            const ExpandableCell(
              title: "Personal Data",
              count: 7,
              icon: "assets/icons/svg/ic_profile_data.svg",
              content: PersonalData(),
            ),
            const SizedBox(
              height: 16,
            ),
            Consumer(
              builder: (context, ref, child) {
                final userState = ref.watch(userStateProvider);

                return ExpandableCell(
                  title: "User State (Debug)",
                  subtitle: userState.name,
                  count: 3,
                  icon: "assets/icons/svg/ic_profile_data.svg",
                  content: const UserStatePicker(),
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
                  title: "Language",
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
            const ExpandableCell(
              title: "About App",
              count: 1,
              icon: "assets/icons/svg/ic_profile_about.svg",
              content: SizedBox(
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
    );
  }
}
