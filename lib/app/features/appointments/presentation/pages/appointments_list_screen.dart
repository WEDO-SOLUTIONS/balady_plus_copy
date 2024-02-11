import 'package:flutter/material.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/base/base_view.dart';
import '../../../../core/utils/app_analytics_events.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/presentation/icons/general_icon.dart';
import '../../../_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import '../../../_shared_feature_/presentation/widgets/need_login_widget.dart';
import '../../../new_appointment/presentation/core/models/my_appointments_response.dart';
import '../core/services/view_models/my_appointments_view_model.dart';

import '../widgets/appointments_widgets/appointment_card.dart';

class AppointmentsListScreen extends StatefulWidget {
  const AppointmentsListScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsListScreen> createState() => _AppointmentsListScreenState();
}

class _AppointmentsListScreenState extends State<AppointmentsListScreen> {
  bool isSuccess = true;

  @override
  void initState() {
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.appointments);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: "appointments".tr(),
        actions: [
          GeneralIcon(
            onTap: () {
              Navigator.of(context).pushNamed(
                RouteName.previousAppointmentsRoute,
              );
            },
            icon: IconPath.calenderTick,
          )
        ],
      ),
      backgroundColor: AppColor.white2,
      body: BaseView<MyAppointmentsViewModel>(
        onModelReady: (model) async {
          isSuccess = await model.getMyAppointments(showErrorMsg: true);
          model.getMyPreviousAppointments(pageIndex: 0);
        },
        builder: (context, model, child) {
          List<AppointmentItem> upcomingList = model.getMyAppointmentsList();
          return RefreshIndicator(
            color: const Color(0xff389492),
            onRefresh: () {
              return model.getMyAppointments(showErrorMsg: true);
            },
            child: model.isLoading
                ? const CustomShimmerListWidget(
                    height: 300,
                  )
                : (upcomingList.isEmpty)
                    ? EmptyListWidget(
                        btnText: ('submit_new_appointment').tr(),
                        title: ('no_appointment').tr(),
                        //  desc: ('no_appointment_desc').tr(),
                        // btnPressed: () {}
                      )
                    : ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          vertical: 30.0,
                          horizontal: Constants.semiMediumPadding,
                        ),
                        children: [
                          if (upcomingList.isNotEmpty)
                            Constants.verticalSpaceMedium,
                          // list of appointments
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: upcomingList.reversed
                                .map(
                                  (appointment) => AppointmentCard(
                                    item: appointment.model,
                                    onPress: () async {
                                      if (appointment.id != null) {
                                        Navigator.of(context).pushNamed(
                                          RouteName.appointmentDetailsRoute,
                                          arguments: {
                                            "appointmentId": appointment.id!,
                                          },
                                        );
                                      }
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                          if (upcomingList.isEmpty)
                            const CustomVerticalSpace(
                              height: 24,
                            ),
                        ],
                      ),
          );
        },
      ),
    );
  }
}
