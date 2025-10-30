import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:dartz/dartz.dart';

import '../../../../comercial_license_renew/domain/entities/cr_attachment_request.dart';
import '../../../../commercial_license/domain/entities/save_shop_details_request.dart';
import '../../data/models/request_attachments/request_attachments.dart';
import '../../data/models/request_attachments/request_attachments.dart';
import '../../data/models/request_permits_model/permit.dart';
import '../../data/models/request_permits_model/request_permits_model.dart';
import '../../data/models/transfer_attachment_response/request_attachments_response.dart';
import '../entities/save_selected_requests_permits_request.dart';
import '../entities/save_shop_info_request.dart';

abstract class RequestApprovalSequenceRepository {
  Future<Either<Failure, RequestPermitsModel>> getRequestPermits(
      int requestNumber);
  Future<Either<Failure, bool>> saveSelectedRequestPermits(int requestNumber,
      SaveSelectedRequestsPermitsRequest saveSelectedRequestsPermitsRequest);
  Future<Either<Failure, bool>> saveShopInfo(
      int requestNumber, SaveShopInfoRequest params);

  Future<Either<Failure, bool>> saveShopDetails(SaveShopDetailsRequest req);
  Future<Either<Failure, List<RequestAttachmentsResponse>>> requestAttachments(
      int requestNumber);
  Future<Either<Failure, bool?>> uploadAttachments(CrAttachmentRequest params);
  Future<Either<Failure, bool>> saveAttachment(CrAttachmentRequest params);
  Future<Either<Failure, bool>> uploadCredence(CrAttachmentRequest params);
  Future<Either<Failure, bool>> submitApprovel(
      int requestNumber);
}
