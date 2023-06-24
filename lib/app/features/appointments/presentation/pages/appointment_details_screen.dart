import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/base/base_view.dart';
import '../../../../core/base/base_view_model.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../new_appointment/presentation/core/models/appointment_details_model.dart';
import '../../../new_appointment/presentation/core/services/view_models/appontment_details_view_model.dart';
import '../dialogs/confirm_cancel_appointment_dialog.dart';
import '../widgets/appointment_details_widgets/appointment_details_card_widget.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  // final int appointmentId;

  AppointmentItemInfo? appointmentItemInfo;
  bool? isCancelable;
  bool? isPrintable;
  bool? fromHomePage;

  AppointmentDetailsScreen(
      {Key? key,
      this.appointmentItemInfo,
      this.isCancelable,
      this.isPrintable,
      this.fromHomePage = false
      // required this.appointmentId,
      })
      : super(key: key);

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  final model = locator<AppointmentDetailsViewModel>();
  AppointmentItemInfo? appointmentItemInfoLocal;

  @override
  void initState() {
    model.fromHomePage = widget.fromHomePage ?? false;
    super.initState();
  }

  @override
  void dispose() {
    model.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AppointmentDetailsViewModel>(
        onModelReady: (model) {},
        builder: (context, model, child) {
          if (widget.appointmentItemInfo != null) {
            appointmentItemInfoLocal = widget.appointmentItemInfo;
          } else {
            appointmentItemInfoLocal = model.getAppointmentsInfo();
          }
          return Scaffold(
            backgroundColor: AppColor.white2,
            appBar: AppBar(
              elevation: 4.0,
              backgroundColor: AppColor.white,
              actions: [
                _AppBarActionsShareIconWidget(
                    appointmentID: appointmentItemInfoLocal!.id ?? 0)
              ],
            ),
            body: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.smallPadding,
                vertical: Constants.mediumPadding,
              ),
              children: [
                if (appointmentItemInfoLocal != null)
                  AppointmentDetailsCardWidget(
                    appointmentData: appointmentItemInfoLocal!,
                    printable: /*model.isPrintableAppointment()*/
                        widget.isPrintable ??
                            appointmentItemInfoLocal!.printable ??
                            false,
                  ),
                if (/*model.showCancelButton()*/ widget.isCancelable ??
                    appointmentItemInfoLocal!.cancelable ??
                    false)
                  const CustomVerticalSpace(height: 40.0),
                if (appointmentItemInfoLocal?.confirmable ?? false) ...[
                  _ConfirmAppointmentWidget(onConfirm: () {
                    model.confirmAppointment();
                  }),
                  Constants.verticalSpaceMedium,
                ],
                if (widget.isCancelable ??
                    appointmentItemInfoLocal!.cancelable ??
                    false)
                  const _CancelAppointmentWidget(),
                Constants.verticalSpaceMedium,
              ],
            ),
          );
        });
  }
}

class _AppBarActionsShareIconWidget extends StatelessWidget {
  int appointmentID;

  _AppBarActionsShareIconWidget({Key? key, required this.appointmentID})
      : super(key: key);
  final model = locator<AppointmentDetailsViewModel>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.smallPadding,
      ),
      child: CustomIconButtonWidget(
        icon: Constants.shareIcon,
        onPressed: () => model.shareAppointmentFunction(appointmentID),
      ),
    );
  }
}

class _CancelAppointmentWidget extends StatelessWidget {
  const _CancelAppointmentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EnhancedCustomElevatedButtonWidget(
      btnPressed: () async => await CustomPopUpsWidgets.showBottomSheet(
        context,
        child: const ConfirmCancelAppointmentDialog(),
        isFullHeight: false,
      ),
      btnBorderColor: AppColor.redBrown,
      btnColor: AppColor.white2,
      btnBorderWidth: 2.0,
      btnText: ("appointmentDetailsCancelAppointmentWord").tr(),
      btnTextColor: AppColor.redBrown,
      btnTextWeight: AppFontWeight.medium,
    );
  }
}

class _ConfirmAppointmentWidget extends StatelessWidget {
  final Function onConfirm;
  const _ConfirmAppointmentWidget({Key? key, required this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EnhancedCustomElevatedButtonWidget(
      btnPressed: () async => onConfirm(),
      btnBorderColor: AppColor.darkTurquoise,
      btnColor: AppColor.white2,
      btnBorderWidth: 2.0,
      btnText: ("appointmentDetailsConfirmAppointmentWord").tr(),
      btnTextColor: AppColor.darkTurquoise,
      btnTextWeight: AppFontWeight.medium,
    );
  }
}
