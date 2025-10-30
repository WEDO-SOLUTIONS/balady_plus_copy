import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../_shared_feature_/data/entities/file_data_item.dart';
import '../../../vd/domain/entities/gis/gis_params.dart';
import '../../data/models/apply_create_compliance_request_model.dart';
import '../../data/models/compliance_certificate_item_request.dart';
import '../../data/models/compliance_certificate_items_request.dart';
import '../../data/models/compliance_engoffice_details_model.dart';
import '../../data/models/complinace_engoffice_response_model.dart';
import '../../data/models/complinace_licenses_response_model.dart';
import '../../data/models/ownership_doc_type_response_model.dart';
import '../../data/models/save_contract_info_request.dart';
import '../../data/models/save_location_compliance_request.dart';
import '../../data/models/upload_dms_attachment_response.dart';
import '../entities/apply_create_compliance_response.dart';
import '../entities/comliance_request_details.dart';
import '../entities/compliance_appointment_response.dart';
import '../entities/compliance_attachment_request.dart';
import '../entities/compliance_deed_info.dart';
import '../entities/compliance_deed_info_request.dart';
import '../entities/compliance_gis_resopnse.dart';
import '../entities/land_subsidy_contract.dart';
import '../entities/land_subsidy_contract_request.dart';
import '../entities/send_otp_response.dart';
import '../entities/submit_emtithal_request.dart';
import '../entities/verify_otp_request.dart';

abstract class CreateComplianceRepository {
  Future<Either<Failure, ComplainceAppointmentResponse>>
      getComplainceAppointment(
    (String, String) params,
  );

  Future<Either<Failure, ApplyCreateComplianceResponse>> applyCreateCompliance(
    ApplyCreateComplianceRequest params,
  );

  Future<Either<Failure, ComplianceRequestDetails>> getComplianceByRequestId(
    String params,
  );

  Future<Either<Failure, bool>> saveLocationCompliance(
    SaveLocationComplianceRequest params,
  );

  Future<Either<Failure, bool>> saveContractInfo(
    SaveContractInfoRequest params,
  );
  Future<Either<Failure, bool>> saveComplianceCertificateItems(
    ComplianceCertificateItemsRequest params,
  );

  Future<Either<Failure, bool>> saveComplianceCertificateItem(
    ComplianceCertificateItemRequest params,
  );

  Future<Either<Failure, (String, bool?)>> submitRequest(
      String id, SubmitEmtithalRequest params);
  Future<Either<Failure, ComplinaceLookUpResponseModel>>
      getOwnerShipDocTypeResponse();

  Future<Either<Failure, ComplinaecLicensesReponseModel>>
      getComplianceLicense();

  Future<Either<Failure, ComplinaceLookUpResponseModel>> getMainUsages();

  Future<Either<Failure, ComplinaceLookUpResponseModel>> getSubUsages(
      {required int mainId});

  Future<Either<Failure, ComplinaecEngOfficeReponseModel>>
      getComplianceEngOffices();

  Future<Either<Failure, ComplianceEngOfficeDetailsModel>>
      getComplianceEngOfficeDetails({required String id});
  Future<Either<Failure, ComplainceGISResponse>> getGISInfo(
      {required GISParams params});

  Future<Either<Failure, bool>> saveAttachment(
      {required ComplinaceAttachmentRequest params});

  Future<Either<Failure, SendOtpResponse>> sendOTP({required String params});

  Future<Either<Failure, bool>> verifyOTP({required VerifyOTPRequest params});
  Future<Either<Failure, Uint8List?>> downLoadCertificate(
      {required String params});

  Future<Either<Failure, bool?>> deleteComplianeRequeest(
      {required String params});

  Future<Either<Failure, String?>> getEtmamId({required String params});

  Future<Either<Failure, ComplinaceLookUpResponseModel>> getReciptTypes();

  Future<Either<Failure, ComplianceDeedInfo>> getDeedInfo(
      ComplianceDeedInfoRequest params);
  Future<Either<Failure, LandSubsidyContract>> getLandContract(
      LandSubsidyContractRequest params);

  Future<Either<Failure, UploadDmsAttachmentResponse>> uploadClauseAttachment(
      FileDataItem params, int requestId);

  Future<Either<Failure, bool>> validateComplianceCertificateItem(int params);

  Future<Either<Failure, bool>> cancelComplianceCertificate(int params);
}
