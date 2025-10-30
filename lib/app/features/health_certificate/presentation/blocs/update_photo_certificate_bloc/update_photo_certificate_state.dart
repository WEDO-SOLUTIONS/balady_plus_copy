part of 'update_photo_certificate_bloc.dart';

class UpdatePhotoCertificateState extends Equatable {
  final BlocStatus status;
  final BlocStatus otpStatus;

  final String? errorMessage;
  final int? requestId;
  final String? versionNo;
  final String? certificateUUID;
  final String? birthDate;
  final UpdatePhotoResponse? updatePhotoResponse;
  final bool? verifyOTPCertificate;
  final SendOtpCertificateResult? sendOtpCertificateResult;

  const UpdatePhotoCertificateState(
      {this.status = BlocStatus.initial,
      this.otpStatus = BlocStatus.initial,
      this.errorMessage,
      this.requestId,
      this.versionNo,
      this.certificateUUID,
      this.birthDate,
      this.updatePhotoResponse,
      this.verifyOTPCertificate,
      this.sendOtpCertificateResult});

  UpdatePhotoCertificateState copyWith(
      {final BlocStatus? status,
      final BlocStatus? otpStatus,
      final String? errorMessage,
      final int? requestId,
      final String? versionNo,
      final String? certificateUUID,
      final String? birthDate,
      final UpdatePhotoResponse? updatePhotoResponse,
      final bool? verifyOTPCertificate,
      final SendOtpCertificateResult? sendOtpCertificateResult}) {
    return UpdatePhotoCertificateState(
        status: status ?? this.status,
        otpStatus: otpStatus ?? this.otpStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        requestId: requestId ?? this.requestId,
        versionNo: versionNo ?? this.versionNo,
        certificateUUID: certificateUUID ?? this.certificateUUID,
        birthDate: birthDate ?? this.birthDate,
        updatePhotoResponse: updatePhotoResponse ?? this.updatePhotoResponse,
        verifyOTPCertificate: verifyOTPCertificate ?? this.verifyOTPCertificate,
        sendOtpCertificateResult:
            sendOtpCertificateResult ?? this.sendOtpCertificateResult);
  }

  bool get isFormValid =>
      (birthDate?.isNotEmpty ?? false) && (versionNo?.isNotEmpty ?? false);
  @override
  List<Object?> get props => [
        status,
        otpStatus,
        errorMessage,
        sendOtpCertificateResult,
        verifyOTPCertificate,
        updatePhotoResponse,
        birthDate,
        certificateUUID,
        versionNo,
        requestId
      ];
}
