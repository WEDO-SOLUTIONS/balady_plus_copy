import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../../data/models/apply_create_compliance_request_model.dart';
import '../entities/apply_create_compliance_response.dart';
import '../entities/compliance_appointment_response.dart';
import '../repositories/repository.dart';

class GetComplianceAppointments
    extends UseCase<ComplainceAppointmentResponse, (String, String)> {
  final CreateComplianceRepository repository;
  GetComplianceAppointments({required this.repository});
  @override
  Future<Either<Failure, ComplainceAppointmentResponse>> call(
      (String, String) params) async {
    return await repository.getComplainceAppointment(params);
  }
}
