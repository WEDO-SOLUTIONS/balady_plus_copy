import 'package:equatable/equatable.dart';

import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../data/models/find_grave_response_model.dart';
import '../../../data/models/send_otp_response.dart';

class EkramInquiryPrintState extends Equatable {
  final String? errorMsg;
  final BlocStatus status;
  final BlocStatus otpStatus;

  final List<LookUpItem>? nationalIdTypes;

  final String? nationalIdForDecassed;
  final LookUpItem? selectedNationalIdTypeForDecassed;

  final String? nationalIdForReceiver;
  final LookUpItem? selectedNationalIdTypeForReceiver;
  final SendOTPResponseModel? sendOtpResponse;

  const EkramInquiryPrintState(
      {this.errorMsg,
      this.status = BlocStatus.initial,
      this.otpStatus = BlocStatus.initial,
      this.nationalIdForDecassed,
      this.nationalIdTypes,
      this.selectedNationalIdTypeForDecassed,
      this.nationalIdForReceiver,
      this.selectedNationalIdTypeForReceiver,
      this.sendOtpResponse});

  @override
  List<Object?> get props => [
        errorMsg,
        status,
        nationalIdTypes,
        nationalIdForDecassed,
        selectedNationalIdTypeForDecassed,
        nationalIdForReceiver,
        selectedNationalIdTypeForReceiver,
        otpStatus,
        sendOtpResponse
      ];

  EkramInquiryPrintState copyWith(
      {final String? errorMsg,
      final BlocStatus? status,
      final List<LookUpItem>? nationalIdTypes,
      final String? nationalIdForDecassed,
      final LookUpItem? selectedNationalIdTypeForDecassed,
      final String? nationalIdForReceiver,
      final LookUpItem? selectedNationalIdTypeForReceiver,
      final BlocStatus? otpStatus,
      final SendOTPResponseModel? sendOtpResponse}) {
    return EkramInquiryPrintState(
        errorMsg: errorMsg ?? this.errorMsg,
        status: status ?? this.status,
        otpStatus: otpStatus ?? this.otpStatus,
        nationalIdTypes: nationalIdTypes ?? this.nationalIdTypes,
        nationalIdForDecassed:
            nationalIdForDecassed ?? this.nationalIdForDecassed,
        selectedNationalIdTypeForDecassed: selectedNationalIdTypeForDecassed ??
            this.selectedNationalIdTypeForDecassed,
        nationalIdForReceiver:
            nationalIdForReceiver ?? this.nationalIdForReceiver,
        selectedNationalIdTypeForReceiver: selectedNationalIdTypeForReceiver ??
            this.selectedNationalIdTypeForReceiver,
        sendOtpResponse: sendOtpResponse ?? this.sendOtpResponse);
  }

  bool isFormValid() {
    if ((nationalIdForDecassed?.isEmpty ?? true) ||
        (nationalIdForReceiver?.isEmpty ?? true) ||
        selectedNationalIdTypeForDecassed == null ||
        selectedNationalIdTypeForReceiver == null) return false;
    return true;
  }
}
