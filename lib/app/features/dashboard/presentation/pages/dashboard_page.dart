import 'package:balady_plus/app/core/utils/app_analytics_events.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/constants.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/constants/analytics_events.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/message_dialogs.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:balady_plus/app/features/dashboard/presentation/widgets/dashboard_card.dart';
import 'package:balady_plus/app/features/dashboard/presentation/widgets/dashboard_list_shimmer.dart';
import 'package:balady_plus/app/features/dashboard/presentation/widgets/no_data_widget.dart';
import 'package:balady_plus/app/features/dashboard/presentation/widgets/volunteer_dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

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
    CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.openDashboard);
    CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.DashBoard_Click_Dashboard_Event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(
        flexibleSpace: const Image(image: AssetImage(ImagePath.appBarBackground), fit: BoxFit.cover),
        title: 'dashboard'.tr(),
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
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,

                                    borderRadius: BorderRadius.all(Radius.circular(16)),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      DrawIconBasedTypeWidget(
                                        icon: IconPath.aboutBalady,
                                        iconColor: Theme.of(context).primaryColor,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: CustomTextWidget(
                                          "the_following_data".tr(),
                                          maxLines: 10,
                                          textStyle: Theme.of(context).textTheme.labelMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.cards.length,
                                  itemBuilder: (context, index) {
                                    if (index == 0) return const VolunteerDashboardCard();
                                    return DashboardCard(
                                      card: state.cards[index - 1],
                                    ); //add index - 1 when uncommenting VolunteerDashboardCard
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
  const NoDataComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 257,
      margin: const EdgeInsets.only(top: 24),
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16)), boxShadow: Constants.boxShadow),
      child: const NoDataWidget(),
    );
  }
}
