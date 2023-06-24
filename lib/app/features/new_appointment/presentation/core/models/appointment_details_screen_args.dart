import 'appointment_details_model.dart';

class AppointmentDetailsScreenArgs {
  final AppointmentItemInfo? appointmentItemInfo;
  final bool? isCancelable;
  final bool? isPrintable;
  final bool? fromHomePage;

  AppointmentDetailsScreenArgs(
      {this.appointmentItemInfo, this.isCancelable, this.isPrintable, this.fromHomePage = false});
}
