import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/base/base_view.dart';
import '../../../../core/base/base_view_model.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import '../../../new_appointment/presentation/core/models/my_appointments_response.dart';
import '../core/services/view_models/my_appointments_view_model.dart';
import '../widgets/appointments_widgets/appointment_card.dart';

class PreviousAppointmentsScreen extends StatefulWidget {
  const PreviousAppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<PreviousAppointmentsScreen> createState() =>
      _PreviousAppointmentsScreenState();
}

class _PreviousAppointmentsScreenState
    extends State<PreviousAppointmentsScreen> {
  late ScrollController _scrollController;
  bool loadMore = false;
  final model = locator<MyAppointmentsViewModel>();

  @override
  void initState() {
    super.initState();
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<MyAppointmentsViewModel>(
      onModelReady: (model) {},
      builder: (context, model, child) {
        List<AppointmentItem> list = model.getMyPreviousAppointmentsList();
        return Scaffold(
          backgroundColor: AppColor.white2,
          appBar: DefaultAppBarWidget(
            title: "previousAppointmentHeaderTitleWord".tr(),
          ),
          body: RefreshIndicator(
            color: const Color(0xff389492),
            onRefresh: () {
              return model.getMyPreviousAppointments(
                  pageIndex: 0, showErrorMsg: true);
            },
            child: ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                vertical: Constants.semiLargePadding,
                horizontal: Constants.semiMediumPadding,
              ),
              itemCount: list.length + 1,
              itemBuilder: (context, index) {
                if (index >= list.length) {
                  if (loadMore) {
                    return const SizedBox(
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColor.baladyDarkGreen2,
                        ),
                      ),
                    );
                  } else {
                    return Container(height: 50);
                  }
                }
                return AppointmentCard(
                  item: list[index].model,
                  onPress: () async {
                    if (list[index].id != null) {
                      Navigator.of(context).pushNamed(
                        RouteName.appointmentDetailsRoute,
                        arguments: {
                          "appointmentId": list[index].id!,
                        },
                      );
                    }
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
