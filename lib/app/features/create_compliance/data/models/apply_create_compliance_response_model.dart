import '../../domain/entities/apply_create_compliance_response.dart';

class ApplyCreateComplianceResponseModel extends ApplyCreateComplianceResponse {
  const ApplyCreateComplianceResponseModel({super.result});

  @override
  List<Object?> get props => [];

  factory ApplyCreateComplianceResponseModel.fromMap(Map<String, dynamic> map) {
    return ApplyCreateComplianceResponseModel(
      result: map['result'] != null ? map['result'] as int : null,
    );
  }
}
