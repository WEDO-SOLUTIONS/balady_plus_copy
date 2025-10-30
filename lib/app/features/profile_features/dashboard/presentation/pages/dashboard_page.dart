import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../../core/utils/app_analytics_events.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, IconPath, RouteName;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show
        CustomTextWidget,
        DefaultAppBarWidget,
        DrawIconBasedTypeWidget,
        MessageDialog;
import '../../../../home_page/home_exports.dart' show CircleIcon;
import '../../dashboard_exports.dart'
    show
        DashboardBloc,
        DashboardCard,
        DashboardEventInitial,
        DashboardListShimmer,
        DashboardState,
        NoDataWidget;

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  @override
  void initState() {
    super.initState();

    CommonFunctions.sendEventToAnalytics(AppEvents.delegators);

    CommonFunctions.sendUXCamEvent(UXCamEvents.openDashboard);

    CommonFunctions.sendUXCamEvent(UXCamEvents.DashBoard_Click_Dashboard_Event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(
        flexibleSpace: const Image(
          image: AssetImage(
            ImagePath.appBarBackground,
          ),
          fit: BoxFit.cover,
        ),
        title: 'dashboard'.tr(),
        actions: const [
          /*Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () =>
                  Navigator.of(context).pushNamed(RouteName.notificationPage),
              child: const CircleIcon(
                backgroundColor: AppColor.primary50Light,
                icon: IconPath.billIcon,
                circleSize: 48.0,
                iconSize: 30.0,
              ),
            ),
          ),*/
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Builder(
          builder: (context) {
            return BlocConsumer<DashboardBloc, DashboardState>(
              listener: (_, state) async {
                switch (state.status) {
                  case BlocRequestStatus.submissionGetFailure:
                    MessageDialog.showErrorNotification(msg: state.error);
                    break;
                  default:
                    break;
                }
              },
              builder: (context, state) {
                switch (state.status) {
                  case BlocRequestStatus.submissionGetLoading:
                    return const DashboardListShimmer();
                  case BlocRequestStatus.submissionGetSuccess:
                    return state.totalCount() == 0 && state.allCardsSuccess()
                        ? const NoDataComponent()
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(16),
                                  padding: const EdgeInsets.all(16),
                                  height: 64,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                    color: AppColor.secondary50Light,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const DrawIconBasedTypeWidget(
                                        icon: IconPath.aboutBalady,
                                        iconColor: AppColor.secondary900Light,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                            top: 4,
                                            start: 4,
                                          ),
                                          child: CustomTextWidget(
                                            "the_following_data".tr(),
                                            maxLines: 10,
                                            textStyle:
                                                AppStyle.dashboardNoteTextStyle,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.cards.length,
                                  itemBuilder: (context, index) {
                                    return DashboardCard(
                                        card: state.cards[index]);
                                  },
                                ),
                              ],
                            ),
                          );
                  default:
                    return const SizedBox.shrink();
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class NoDataComponent extends StatelessWidget {
  const NoDataComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 257,
      margin: const EdgeInsets.only(top: 24),
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: AppColor.white,
        boxShadow: Constants.boxShadow,
      ),
      child: const NoDataWidget(),
    );
  }
}
