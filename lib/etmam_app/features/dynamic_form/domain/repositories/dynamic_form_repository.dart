import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/bidding_type/bidding_type_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/form_data_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/get_data_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/offers/get_offers_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/offers/offers_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/submit/submit_form_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/submit/submit_form_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/validate/validate_form_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/validate/validate_form_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/dynamic_forms_exports.dart';
import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse;

import '../../../../../app/features/_shared_feature_/data/entities/drop_down_item.dart';
import '../../../../core/errors/errors_exports.dart' show Failure;

abstract class DynamicFormsRepository {
  Future<Either<Failure, ApigeeResponse<List<CreateFormItemResponse>>>>
      createBiddingForm({required CreateFormParams params});

  Future<Either<Failure, ApigeeResponse<List<DropDownItem>>>> getFormFieldData(
      {required GetDataParams params});

  Future<Either<Failure, ApigeeResponse<List<BiddingTypeResponse>>>>
      findByRequestType();

  Future<Either<Failure, ApigeeResponse<SubmitFormResponse>>> submitForm(
      {required SubmitFormParams params});

  Future<Either<Failure, ApigeeResponse<ValidateFormResponse>>> validateForm(
      {required ValidateFormParams params});

  Future<Either<Failure, ApigeeResponse<FormDataResponse>>> getFormData(
      {required String paramas});

  Future<Either<Failure, ApigeeResponse<OffersResponse>>> getOffers(
      {required GetOffersParams paramas});

  Future<Either<Failure, ApigeeResponse<dynamic>>> acceptOffer(
      {required String paramas});
  Future<Either<Failure, ApigeeResponse<dynamic>>> cancelRequest(
      {required String paramas});
  Future<Either<Failure, ApigeeResponse<dynamic>>> rejectOffer(
      {required String paramas});

  Future<Either<Failure, ApigeeResponse<dynamic>>> submitOrder(
      {required String paramas});

  Future<Either<Failure, ApigeeResponse<CreateFormItemResponse>>>
      getEditFormData({required String paramas});

  Future<Either<Failure, ApigeeResponse<SubmitFormResponse>>> editForm(
      {required SubmitFormParams params});

  Future<Either<Failure, ApigeeResponse<UploadBidAttachmentResponse>>>
      uploadBidAttachment(UploadBidAttachment params);
}
