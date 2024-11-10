import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/model/driver/transport_request_item_model.dart';
import '../../data/model/driver/trip_details_model.dart';
import '../../data/model/request_details_response_model/request_details_response_model.dart';
import '../entities/trip_details.dart';
import '../repositories/ekram_repository.dart';

class GetRequestDetails extends UseCase<ResponseBodyModel<RequestDetailsResponseModel>,
    int> {
  final EkramRepository repository;

  GetRequestDetails({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<RequestDetailsResponseModel>>> call(
      int requestId) async {
    return await repository.requestDetails(requestId);
  }
}
