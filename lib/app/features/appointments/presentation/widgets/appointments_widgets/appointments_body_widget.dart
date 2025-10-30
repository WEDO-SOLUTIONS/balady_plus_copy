import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/base/base_view.dart';
import '../../../../../core/base/base_view_model.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/need_login_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../new_appointment/presentation/core/models/my_appointments_response.dart';
import '../../core/services/view_models/my_appointments_view_model.dart';

class AppointmentsBodyWidget extends StatefulWidget {
  const AppointmentsBodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<AppointmentsBodyWidget> createState() => _AppointmentsBodyWidgetState();
}

class _AppointmentsBodyWidgetState extends State<AppointmentsBodyWidget> {
  final model = locator<MyAppointmentsViewModel>();

  @override
  void initState() {
    super.initState();
    model.getMyAppointments(showErrorMsg: true);
    model.getMyPreviousAppointments(pageIndex: 0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<MyAppointmentsViewModel>(
        onModelReady: (model) {},
        builder: (context, model, child) {
          List<AppointmentItem> upcomingList = model.getMyAppointmentsList();
          List<AppointmentItem> previousList =
              model.getMyPreviousAppointmentsList();
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
                            // upcoming appointments word
                            if (upcomingList.isNotEmpty)
                              CustomTextWidget(
                                ("appointmentsUpComingAppointmentsWord").tr(),
                                fontSize: 24.0,
                                fontColor: AppColor.black,
                                textAlign: TextAlign.start,
                              ),
                            if (upcomingList.isNotEmpty)
                              Constants.verticalSpaceMedium,
                            // list of appointments
                            (upcomingList.isEmpty)
                                ? EmptyListWidget(
                                    btnText: ('submit_new_appointment').tr(),
                                    title: ('no_upcoming_appointment').tr(),
                                    desc: ('no_upcoming_appointment_desc').tr(),
                                    img: "noAppointmentsIllustration@3x.png",
                                    /*             btnPressed: () async {
                                      await CustomPopUpsWidgets.showBottomSheet(
                                        context,
                                        child:
                                             BookNewAppointmentSheetWidget(fromHomePage: false,),
                                      );
                                    }*/
                                    btnPressed: () => Navigator.of(context)
                                        .pushNamed(RouteName.NewAppointmentPage,
                                            arguments: null),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: upcomingList.reversed
                                        .map((appointment) => Container())
                                        .toList(),
                                  ),
                            if (upcomingList.isEmpty)
                              const CustomVerticalSpace(
                                height: 24,
                              ),
                          ],
                        ));
        });
  }
}
