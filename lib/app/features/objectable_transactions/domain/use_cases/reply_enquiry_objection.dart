import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../../objections_exports.dart';
import '../entities/enquiry_objection_reply_params.dart';

class ReplyEnquiryObjectionDetails
    extends UseCase<dynamic, EnquiryObjectionReplyDetails> {
  final RequestsRepository repository;
  ReplyEnquiryObjectionDetails({required this.repository});
  @override
  Future<Either<Failure, dynamic>> call(
      EnquiryObjectionReplyDetails params) async {
    return await repository.replyEnquiryObjectionDetails(params);
  }
}
