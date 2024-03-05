import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../../objections_exports.dart';
import '../entities/objection_enquiry_details.dart';

class GetEnquiryObjectionDetails
    extends UseCase<ObjectionEnquiryDetails, String> {
  final RequestsRepository repository;
  GetEnquiryObjectionDetails({required this.repository});
  @override
  Future<Either<Failure, ObjectionEnquiryDetails>> call(String params) async {
    return await repository.getEnquiryObjectionDetails(params);
  }
}
