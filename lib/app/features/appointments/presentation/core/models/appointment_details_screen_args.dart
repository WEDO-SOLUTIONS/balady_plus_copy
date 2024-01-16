import '../../../../new_appointment/presentation/core/models/appointment_details_model.dart';

class AppointmentDetailsScreenArgs {
  final AppointmentItemInfo? appointmentItemInfo;
  final bool? isCancelable;
  final bool? isPrintable;
  final bool? fromHomePage;
  final bool? isEditable;

  AppointmentDetailsScreenArgs(
      {this.appointmentItemInfo,
      this.isCancelable,
      this.isPrintable,
      this.isEditable,
      this.fromHomePage = false});
}
