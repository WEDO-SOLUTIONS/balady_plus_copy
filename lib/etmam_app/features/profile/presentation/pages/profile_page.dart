import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/etmam_app/core/services/services_exports.dart';
import 'package:balady_plus/etmam_app/core/utils/common_functions.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart'
    show AuthStatus, BlocStatus;

import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AuthStatus;
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_plus/etmam_app/features/profile/profile_exports.dart'
    show
        FooterWidget,
        LogoutWidget,
        NotAuthorizedLoginWidget,
        ProfileHeader,
        ProfileHeaderItem,
        ProfileItem;
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../_shared_feature_/shared/shared_feature_exports.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.Profile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: trans("my_profile"),
          withBackImg: false,
        ),
        body: BlocConsumer<EntryPointCubit, EntryPointState>(
          listener: (context, state) {
            if (state.status == AuthStatus.failure) {
              CommonFunctions.showError(state.errorMessage ?? "");
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CustomVerticalSpace(height: 24),
                        state.status != AuthStatus.authenticated
                            ? const NotAuthorizedLoginWidget()
                            : const ProfileHeader(),
                        const CustomVerticalSpace(height: 12),
                        const ProfileItemsSection(),
                        const CustomVerticalSpace(height: 90),
                        const FooterWidget(),
                        const CustomVerticalSpace(height: 18),
                        if (state.status == AuthStatus.authenticated)
                          LogoutWidget(onPress: () {
                            context.read<EntryPointCubit>().clearAuth();
                          }),
                        const CustomVerticalSpace(height: 18),
                      ],
                    ),
                  ),
                ),
                if (state.status == BlocStatus.loading)
                  const CustomLoadingWidget()
              ],
            );
          },
        ));
  }
}

class ProfileItemsSection extends StatelessWidget {
  const ProfileItemsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntryPointCubit, EntryPointState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              padding:
                  const EdgeInsetsDirectional.only(start: 16, top: 16, end: 16),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: AppColor.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color(0x14d1d5db),
                        offset: Offset(-4, 8),
                        blurRadius: 8,
                        spreadRadius: 0)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status == AuthStatus.authenticated) ...[
                    ProfileHeaderItem(
                        title: trans("account"), showTopPadding: false),
                    ProfileItem(
                      title: trans("personal_data"),
                      onPressed: () {
                        NavigationService.pushNamed(
                            routeName: EtmamRoutesNames.personalInfoRoute);
                      },
                      showBottomLine: true,
                    ),
                  ],
                  ProfileHeaderItem(
                    title: trans("etmam_support"),
                    showTopPadding: (state.status == AuthStatus.authenticated)
                        ? true
                        : false,
                  ),
                  // ProfileItem(
                  //   topPadding: state.status == AuthStatus.authenticated ? 21 : 0,
                  //   title: trans("settings"),
                  //   showBottomLine: true,
                  //   onPressed: () {},
                  // ),
                  ProfileItem(
                    title: trans("help"),
                    onPressed: () {
                      NavigationService.pushNamed(
                          routeName: EtmamRoutesNames.helpRoute);
                    },
                  ),
                ],
              ),
            ),
            if (state.status == AuthStatus.loading ||
                state.blocStatus == BlocStatus.loading)
              const CustomLoadingWidget()
          ],
        );
      },
    );
  }
}
