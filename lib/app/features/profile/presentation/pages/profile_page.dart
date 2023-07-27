import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/utils_exports.dart'
    show CommonProperties, ImagePath;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show DefaultAppBarWidget, ElevatedButtonWidget, TabPageContainer;
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
        bool isLoggedin = CommonProperties.isLoggedIn;
        final list = isLoggedin
            ? ProfileSections.profileSections
            : ProfileSections.profileSectionsForGuest;
        return Scaffold(
          appBar: DefaultAppBarWidget(
            title: "profile".tr(),
            flexibleSpace: const Image(
              image: AssetImage(ImagePath.appBarGradientBackground),
              fit: BoxFit.cover,
            ),
          ),
          body: TabPageContainer(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BlocBuilder<DelegatorsCubit, DelegatorsState>(
                    builder: (context, state) {
                      return ProfileCard(
                        isListItem: false,
                        delegator: isLoggedin ? state.selectedDelegate : null,
                        userInfo: isLoggedin ? CommonProperties.userInfo : null,
                      );
                    },
                  ),
                  if (!isLoggedin) const SignInCard(),
                  ...List.generate(
                    list.length,
                    (index) => ProfileListCard(
                      section: list[index],
                    ),
                  ),
                  if (isLoggedin)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButtonWidget.logout(onPressed: () {
                        sl<EntryPointCubit>().clearAuth();
                      }),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
