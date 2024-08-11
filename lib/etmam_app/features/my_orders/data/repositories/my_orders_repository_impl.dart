import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse;
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_details/request_details_response.dart';

import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/cancel_order_params.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/cancel_order_response.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_details/order_details_response.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_details/order_details_params.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/orders_response.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/get_orders_params.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/rating/rating_item.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/use_cases/submit_rating_params.dart';
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show
        MyOrdersRemoteDataSource,
        MyOrdersLocalDataSource,
        MyOrdersRepository,
        RequestResponseModel;
import '../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;
import 'package:balady_plus/app/events_logs/balady_logs.dart';


class MyOrdersRepositoryImpl implements MyOrdersRepository {
  final MyOrdersRemoteDataSource remoteDataSource;
  final MyOrdersLocalDataSource localDataSource;

  MyOrdersRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, ApigeeResponse<OrdersResponse>>> getMyOrders(
      {required GetOrdersParams params}) async {
    try {
      final data = await remoteDataSource.getMyOrders(params: params);

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse<CancelOrderResponse>>> cancelOrder(
      {required CancelOrderParams params}) async {
    try {
      final data = await remoteDataSource.cancelOrders(params: params);

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse<List<RatingItem>>>>
      getRatingItems() async {
    try {
      final data = await remoteDataSource.getRatingItems();

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse<OrderDetailsResponse>>> getOrderDetails(
      {required OrderDetailsParams params}) async {
    try {
      final data = await remoteDataSource.getOrderDetails(params: params);

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse>> submitRate(
      {required SubmitRatingParams params}) async {
    try {
      final data = await remoteDataSource.submitRating(params: params);

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse<RequestResponseModel>>> getMyRequests(
      {required GetOrdersParams params}) async {
    try {
      final data = await remoteDataSource.getMyRequests(params: params);

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse<RequestDetailsResponse>>>
      getRequestDetails({required OrderDetailsParams params}) async {
    try {
      final data = await remoteDataSource.getRequestDetails(params: params);

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }
}
