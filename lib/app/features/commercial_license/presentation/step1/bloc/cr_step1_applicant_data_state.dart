part of 'cr_step1_applicant_data_cubit.dart';

class CrStep1ApplicantDataState extends Equatable {
  final RecordInfo? recordInfo;
  final BlocStatus recordStatus;
  final String errorMessage;

  const CrStep1ApplicantDataState({
    this.recordInfo,
    this.recordStatus = BlocStatus.initial,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [
        recordInfo,
        recordStatus,
        errorMessage,
      ];

  CrStep1ApplicantDataState copyWith({
    RecordInfo? recordInfo,
    BlocStatus? recordStatus,
    String? errorMessage,
  }) {
    return CrStep1ApplicantDataState(
      recordInfo: recordInfo ?? this.recordInfo,
      recordStatus: recordStatus ?? this.recordStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
