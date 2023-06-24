import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
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
    show ProfileCard, ProfileListCard, ProfileSections, SignInCard;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntryPointCubit, EntryPointState>(
      builder: (context, state) {
        final list = CommonProperties.isLoggedIn
            ? ProfileSections.profileSections
            : ProfileSections.profileSectionsForGuest;
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
                        delegator: CommonProperties.isLoggedIn
                            ? state.selectedDelegate
                            : null,
                        userInfo: CommonProperties.isLoggedIn
                            ? CommonProperties.userInfo
                            : null,
                      );
                    },
                  ),
                  if (!CommonProperties.isLoggedIn) const SignInCard(),
                  ...List.generate(
                    list.length,
                    (index) => ProfileListCard(
                      section: list[index],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
