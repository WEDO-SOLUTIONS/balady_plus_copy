import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show UseCase;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';

import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show
        OrdersResponse,
        GetOrdersParams,
        MyOrdersRepository,
        RequestResponseModel;
import '../../../../core/errors/errors_exports.dart' show Failure;

class GetMyRequests
    extends UseCase<ApigeeResponse<RequestResponseModel>, GetOrdersParams> {
  final MyOrdersRepository repository;

  GetMyRequests({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<RequestResponseModel>>> call(
      GetOrdersParams params) async {
    return await repository.getMyRequests(params: params);
  }
}
