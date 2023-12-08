import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_details/request_details_response.dart';
import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse;
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/cancel_order_params.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_details/order_details_params.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_details/order_details_response.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/use_cases/submit_rating_params.dart';
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show
        OrdersResponse,
        GetOrdersParams,
        CancelOrderResponse,
        RatingItem,
        RequestResponseModel;

import '../../../../core/errors/errors_exports.dart' show Failure;

abstract class MyOrdersRepository {
  Future<Either<Failure, ApigeeResponse<RequestResponseModel>>> getMyRequests(
      {required GetOrdersParams params});

  Future<Either<Failure, ApigeeResponse<OrdersResponse>>> getMyOrders(
      {required GetOrdersParams params});

  Future<Either<Failure, ApigeeResponse<CancelOrderResponse>>> cancelOrder(
      {required CancelOrderParams params});

  Future<Either<Failure, ApigeeResponse<List<RatingItem>>>> getRatingItems();

  Future<Either<Failure, ApigeeResponse<OrderDetailsResponse>>> getOrderDetails(
      {required OrderDetailsParams params});

  Future<Either<Failure, ApigeeResponse>> submitRate(
      {required SubmitRatingParams params});

  Future<Either<Failure, ApigeeResponse<RequestDetailsResponse>>>
      getRequestDetails({required OrderDetailsParams params});
}
