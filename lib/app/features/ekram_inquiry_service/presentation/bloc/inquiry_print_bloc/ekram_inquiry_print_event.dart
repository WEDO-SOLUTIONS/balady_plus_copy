import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:equatable/equatable.dart';

abstract class EkramInquiryPrintEvent extends Equatable {
  const EkramInquiryPrintEvent();

  @override
  List<Object> get props => [];
}

class FindCemetriesEvent extends EkramInquiryPrintEvent {
  const FindCemetriesEvent();
}

class UpdatePrintFieldsEvent extends EkramInquiryPrintEvent {
  final String? nationalIdForDecassed;
  final LookUpItem? selectedNationalIdTypeForDecassed;

  final String? nationalIdForReceiver;
  final LookUpItem? selectedNationalIdTypeForReceiver;

  const UpdatePrintFieldsEvent(
      {this.nationalIdForDecassed,
      this.selectedNationalIdTypeForDecassed,
      this.nationalIdForReceiver,
      this.selectedNationalIdTypeForReceiver});
}

class PrintSendOTPEvent extends EkramInquiryPrintEvent {
  final bool resend;
  const PrintSendOTPEvent({this.resend = false});
}

class VerifySendOTPEvent extends EkramInquiryPrintEvent {
  final String? otp;
  const VerifySendOTPEvent({this.otp});
}
