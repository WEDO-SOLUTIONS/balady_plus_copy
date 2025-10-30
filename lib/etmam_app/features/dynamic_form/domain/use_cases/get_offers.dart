import 'package:balady_plus/etmam_app/core/services/local/use_case.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/form_data_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/offers/get_offers_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/offers/offers_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/dynamic_forms_exports.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;

class GetOffers
    extends UseCase<ApigeeResponse<OffersResponse>, GetOffersParams> {
  final DynamicFormsRepository repository;

  GetOffers({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<OffersResponse>>> call(
      GetOffersParams params) async {
    return await repository.getOffers(paramas: params);
  }
}
