import '../../../../new_appointment/presentation/core/models/appointment_details_model.dart';

class AppointmentDetailsScreenArgs {
  final int appointmentId;
  final bool? isCancelable;
  final bool? isPrintable;
  final bool? fromHomePage;
  final bool? isEditable;

  AppointmentDetailsScreenArgs({
    required this.appointmentId,
    this.isCancelable,
    this.isPrintable,
    this.isEditable,
    this.fromHomePage = false,
  });
}
