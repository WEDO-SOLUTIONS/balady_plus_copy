import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../core/utils/utils_exports.dart' show CommonProperties;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show TabPageContainer, DefaultAppBarWidget;
import '../../../profile_features/delegators/delegators_exports.dart'
    show DelegatorsCubit, DelegatorsState;
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
              BlocBuilder<DelegatorsCubit, DelegatorsState>(
                builder: (context, state) {
                  return ProfileCard(
                    isListItem: false,
                    delegator: state.selectedDelegate,
                    userInfo: CommonProperties.userInfo,
                  );
                },
              ),
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
