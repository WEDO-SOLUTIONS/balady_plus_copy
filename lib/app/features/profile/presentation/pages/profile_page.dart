import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../_shared_feature_/shared_feature_exports.dart'
    show TabPageContainer, DefaultAppBarWidget;
import '../../profile_exports.dart'
    show ProfileCard, ProfileListCard, ProfileSections;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: "profile".tr(),
      ),
      body: TabPageContainer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const ProfileCard(),
              ...List.generate(
                ProfileSections.profileSections.length,
                (index) => ProfileListCard(
                  section: ProfileSections.profileSections[index],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
