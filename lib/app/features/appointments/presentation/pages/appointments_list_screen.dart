import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/features/appointments/presentation/core/models/appointment_card_item.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:flutter/material.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/base/base_view.dart';
import '../../../../core/base/base_view_model.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/presentation/icons/general_icon.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import '../../../_shared_feature_/presentation/widgets/need_login_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../new_appointment/presentation/core/models/appointment_details_model.dart';
import '../../../new_appointment/presentation/core/models/my_appointments_response.dart';
import '../core/models/appointment_details_screen_args.dart';
import '../core/services/view_models/appontment_details_view_model.dart';
import '../core/services/view_models/my_appointments_view_model.dart';

import '../../../../core/utils/constants/app_colors.dart';
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
    //MM Helpers.sendEventToAnalytics(AppEvents.Appointments_MiniApp);
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
              Navigator.of(context)
                  .pushNamed(RouteName.previousAppointmentsRoute);
            },
            icon: IconPath.calendarIcon,
          )
        ],
      ),
      backgroundColor: AppColor.white2,
      body: BaseView<MyAppointmentsViewModel>(onModelReady: (model) async {
        isSuccess = await model.getMyAppointments(showErrorMsg: true);
        model.getMyPreviousAppointments(pageIndex: 0);
      }, builder: (context, model, child) {
        List<AppointmentItem> upcomingList = model.getMyAppointmentsList();
        List<AppointmentItem> previousList =
            model.getMyPreviousAppointmentsList();
        var detailsModel = locator<AppointmentDetailsViewModel>();
        return RefreshIndicator(
            color: const Color(0xff389492),
            onRefresh: () {
              return model.getMyAppointments(showErrorMsg: true);
            },
            child: model.isLoading
                ? const CustomCircularLoadingWidget()
                : (previousList.isEmpty && upcomingList.isEmpty)
                    ? EmptyListWidget(
                        btnText: ('submit_new_appointment').tr(),
                        title: ('no_appointment').tr(),
                        desc: ('no_appointment_desc').tr(),
                        img: "noAppointmentsIllustration@3x.png",
                        btnPressed: () {})
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
                                .map((appointment) => AppointmentCard(
                                      item: appointment.model,
                                      onPress: () async {
                                        if (appointment.id != null) {
                                          bool isSuccess = false;
                                          AppointmentItemInfo?
                                              appointmentItemInfo;
                                          isSuccess = await detailsModel
                                              .getAppointmentDetails(
                                                  appointment.id ?? -1);
                                          if (isSuccess) {
                                            appointmentItemInfo = detailsModel
                                                .getAppointmentsInfo();
                                          }
                                          if (isSuccess &&
                                              appointmentItemInfo != null) {
                                            Navigator.of(context).pushNamed(
                                                RouteName
                                                    .appointmentDetailsRoute,
                                                // arguments: appointmentData.id ?? 0
                                                arguments:
                                                    AppointmentDetailsScreenArgs(
                                                        appointmentItemInfo:
                                                            appointmentItemInfo,
                                                        isCancelable:
                                                            appointment
                                                                .cancelable,
                                                        isPrintable: appointment
                                                            .printable,
                                                        fromHomePage: true));
                                          }
                                        }
                                      },
                                    ))
                                .toList(),
                          ),
                          if (upcomingList.isEmpty)
                            const CustomVerticalSpace(
                              height: 24,
                            ),
                        ],
                      ));
      }),
    );
  }
}
