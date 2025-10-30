import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_plus/app/features/profile_features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:balady_plus/app/features/services/presentation/pages/dashboard_page/presentation/widgets/dashboard_card_widget.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/enhanced_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../../../../core/utils/utils_exports.dart'
    show AppColor, CommonFunctions, CommonProperties;
import '../../../../../../_shared_feature_/shared_feature_exports.dart'
    show DefaultAppBarWidget, ElevatedButtonWidget, TabPageContainer;
import '../../../../../../profile_features/delegators/delegators_exports.dart'
    show DelegatorsCubit, DelegatorsState;
import '../../dashboard_page_exports.dart'
    show ProfileCard, ProfileListCard, ProfileSections, SignInCard;

class DashbordDataPage extends StatefulWidget {
  const DashbordDataPage({super.key});

  @override
  State<DashbordDataPage> createState() => _DashbordDataPageState();
}

class _DashbordDataPageState extends State<DashbordDataPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<DelegatorsCubit>(),
      child: BlocBuilder<EntryPointCubit, EntryPointState>(
        builder: (context, state) {
          bool isLoggedin = CommonProperties.isLoggedInMunicipality;
          final list = ProfileSections.profileSections;

          return Scaffold(
            backgroundColor: AppColor.white,
            appBar: EnhancedAppBar(
              title: "dashboard".tr(),
              showBack: true,
              actions: [],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  BlocBuilder<DelegatorsCubit, DelegatorsState>(
                    builder: (context, state) {
                      return ProfileCard(
                        isListItem: false,
                        agent: isLoggedin ? state.selectedAgent : null,
                        delegator: isLoggedin ? state.selectedDelegate : null,
                        userInfo: isLoggedin ? CommonProperties.userInfo : null,
                      );
                    },
                  ),

                  // Dashboard
                  if (CommonProperties.isLoggedInMunicipality) ...[
                    // HeaderWithAll(
                    //   text: "dashboard".tr(),
                    //   margin: const EdgeInsets.all(16),
                    //   onPressAll: () {
                    //     // NavigationService.navigatorKey.currentState!.pushNamed(
                    //     //     RouteName.DashbordDataPage,
                    //     //     arguments: context.read<DelegatorsCubit>());
                    //     CommonFunctions.sendUXCamEvent(
                    //         UXCamEvents.DashBoard_Click_View_All_Event);
                    //   },
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: BlocBuilder<DashboardBloc, DashboardState>(
                        builder: (context, dashboardState) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: dashboardState.cards
                                    .map(
                                      (e) => DashboardCardWidget(
                                    card: e,
                                    totalCount: dashboardState
                                        .cardsStates[e]?.totalCount ??
                                        0,
                                  ),
                                )
                                    .toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  //   if (!isLoggedin) const SignInCard(),
                  ...List.generate(
                    list.length,
                    (index) => GestureDetector(
                      child: ProfileListCard(
                        section: list[index],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
