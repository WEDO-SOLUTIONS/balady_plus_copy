import 'package:balady_plus/etmam_app/features/etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';
import 'package:balady_plus/etmam_app/features/my_orders/data/models/request_details_response_model.dart';
import 'package:balady_plus/etmam_app/core/utils/common_functions.dart';
import 'package:balady_plus/etmam_app/core/utils/common_properties.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse, ApigeeResponseModel;

import 'package:dio/dio.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart'
    show ServerException;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show ApiUrl, ApiParams, WithDelay;
import 'package:balady_plus/etmam_app/features/my_orders/data/models/order_details_response_model.dart';
import 'package:balady_plus/etmam_app/features/my_orders/data/models/rating_item_model.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_details/order_details_params.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/use_cases/submit_rating_params.dart';
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show
        OrdersResponseModel,
        GetOrdersParams,
        CancelOrderResponseModel,
        CancelOrderParams,
        RequestResponseModel,
        RequestItemModel,
        CancelOrderResponse;

import '../../../../../app/core/dependency_injection/injection_container.dart';
import '../../../../../app/core/services/global/web_service.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class MyOrdersRemoteDataSource {
  Future<ApigeeResponse<RequestResponseModel>> getMyRequests(
      {required GetOrdersParams params});

  Future<ApigeeResponse<OrdersResponseModel>> getMyOrders(
      {required GetOrdersParams params});

  Future<ApigeeResponse<CancelOrderResponse>> cancelOrders(
      {required CancelOrderParams params});

  Future<ApigeeResponse<List<RatingItemModel>>> getRatingItems();

  Future<ApigeeResponse<OrderDetailsResponseModel>> getOrderDetails(
      {required OrderDetailsParams params});

  Future<ApigeeResponse<RequestDetailsResponseModel>> getRequestDetails(
      {required OrderDetailsParams params});

  Future<ApigeeResponse> submitRating({required SubmitRatingParams params});
}

class MyOrdersRemoteDataSourceImpl extends MyOrdersRemoteDataSource {
  final WebService webService;

  MyOrdersRemoteDataSourceImpl({required this.webService});

  @override
  Future<ApigeeResponse<OrdersResponseModel>> getMyOrders(
      {required GetOrdersParams params}) async {
    var response;

    try {
      response = await webService.dio.get(ApiUrl.myOrders,
          queryParameters: {
            ApiParams.page_No: params.pageIndex,
            ApiParams.page_Size: 10,
            ApiParams.profileId: CommonProperties.profileId,
            if (params.closed != null) ApiParams.closed: params.closed,
            if (params.hasPendingCancelRequest != null)
              ApiParams.hasPendingCancelRequest: params.hasPendingCancelRequest,
          },
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));

      var data = response.data["data"]?["result"];

      var parsedResult =
          data != null ? OrdersResponseModel.fromMap(data) : null;
      final decodedResponse = ApigeeResponseModel<OrdersResponseModel>.fromMap(
          response.data,
          parsedResult: parsedResult);
      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      // Temp Code to handle only the empty list in my orders
      var errorCode;
      try {
        final decodedResponse =
            ApigeeResponseModel<OrdersResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode,
          errorCode: errorCode,
          dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException)
        throw error;
      else {
        try {
          CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException(trans("errors_server_error_2"));
      }
    }
  }

  @override
  Future<ApigeeResponse<CancelOrderResponse>> cancelOrders(
      {required CancelOrderParams params}) async {
    var response;

    try {
      // final response = await webService.dio.post(
      //     ApiUrl.cancelOrder.replaceAll("{}", params.orderId ?? ""),
      //     queryParameters: {
      //       ApiParams.profileId: CommonProperties.profileId,
      //     },
      //     options: Options(headers: {
      //       "Authorization": "Bearer " + (CommonProperties.token ?? "")
      //     }));
      response = await webService.dio.post(
          ApiUrl.cancelOrder.replaceAll("{}", params.orderId ?? ""),
          data: {
            ApiParams.profileId: CommonProperties.profileId,
            'reason': params.purpose ?? "",
          },
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));

      var data = response.data["data"]?["result"];

      var parsedResult =
          data != null ? CancelOrderResponseModel.fromMap(data) : null;
      final decodedResponse =
          ApigeeResponseModel<CancelOrderResponseModel>.fromMap(response.data,
              parsedResult: parsedResult);
      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException)
        throw error;
      else {
        try {
          CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException(trans("errors_server_error_2"));
      }
    }
  }

  @override
  Future<ApigeeResponse<List<RatingItemModel>>> getRatingItems() async {
    var response;

    try {
      response = await webService.dio.get(ApiUrl.ratingItems,
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));

      var data = response.data["data"]?["result"];

      List<RatingItemModel> parsedResult = data != null
          ? List<RatingItemModel>.from(
              data.map((x) => RatingItemModel.fromMap(x)))
          : [];

      final decodedResponse =
          ApigeeResponseModel<List<RatingItemModel>>.fromMap(response.data,
              parsedResult: parsedResult);
      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException)
        throw error;
      else {
        try {
          CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException(trans("errors_server_error_2"));
      }
    }
  }

  @override
  Future<ApigeeResponse<OrderDetailsResponseModel>> getOrderDetails(
      {required OrderDetailsParams params}) async {
    var response;

    try {
      response = await webService.dio.get(ApiUrl.orderDetails + params.orderId!,
          queryParameters: {
            ApiParams.profileId: CommonProperties.profileId,
          },
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));

      var data = response.data["data"]?["result"];

      var parsedResult =
          data != null ? OrderDetailsResponseModel.fromMap(data) : null;
      final decodedResponse =
          ApigeeResponseModel<OrderDetailsResponseModel>.fromMap(response.data,
              parsedResult: parsedResult);
      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException)
        throw error;
      else {
        try {
          CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException(trans("errors_server_error_2"));
      }
    }
  }

  @override
  Future<ApigeeResponse> submitRating(
      {required SubmitRatingParams params}) async {
    var response;

    try {
      response = await webService.dio.post(
          ApiUrl.submitOrderRating + params.orderId!,
          data: {
            "profileId": CommonProperties.profileId,
            "review": params.review,
            "ratings": params.items
                ?.map((e) => {"rate": e.value, "typeId": e.id})
                .toList()
          },
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));

      var data = response.data["data"]?["result"];

      final decodedResponse = ApigeeResponseModel.fromMap(
        response.data,
      );
      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException)
        throw error;
      else {
        try {
          CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException(trans("errors_server_error_2"));
      }
    }
  }

  @override
  Future<ApigeeResponse<RequestResponseModel>> getMyRequests(
      {required GetOrdersParams params}) async {
    var response;

    try {
      response = await webService.dio.get(ApiUrl.myRequests,
          queryParameters: {
            ApiParams.page_No: params.pageIndex,
            ApiParams.page_Size: 10,
            ApiParams.profileId: CommonProperties.profileId,
            "service-classifications":
                sl<EtmamEntryPointCubit>().classificationId,
            if (params.closed != null) "closed-status": params.closed,
          },
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));

      var data = response.data["data"]?["result"];

      var parsedResult =
          data != null ? RequestResponseModel.fromMap(data) : null;
      final decodedResponse = ApigeeResponseModel<RequestResponseModel>.fromMap(
          response.data,
          parsedResult: parsedResult);
      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      // Temp Code to handle only the empty list in my orders
      var errorCode;
      try {
        final decodedResponse =
            ApigeeResponseModel<RequestResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode,
          errorCode: errorCode,
          dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException(trans("errors_server_error_2"));
      }
    }
  }

  @override
  Future<ApigeeResponse<RequestDetailsResponseModel>> getRequestDetails(
      {required OrderDetailsParams params}) async {
    var response;

    try {
      response = await webService.dio.get(
          ApiUrl.requestDetails + params.orderId!,
          queryParameters: {
            ApiParams.profileId: CommonProperties.profileId,
          },
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));

      var data = response.data["data"]?["result"];

      var parsedResult =
          data != null ? RequestDetailsResponseModel.fromMap(data) : null;
      final decodedResponse =
          ApigeeResponseModel<RequestDetailsResponseModel>.fromMap(
              response.data,
              parsedResult: parsedResult);
      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException)
        throw error;
      else {
        try {
          CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException(trans("errors_server_error_2"));
      }
    }
  }

/*
  @override
  Future<ApigeeResponse<MainServicesResponseModel>> getMainServices(
      {required MainServiceParams params}) async {
    try {
      
      final response = await webService.dio.get(
        ApiUrl.mainServices,
        queryParameters: {
          ApiParams.pageNo: params.pageIndex,
          // ApiParams.cityId: params.cityId
        },
      );
      
      
      var data = response.data["data"]?["result"];
      
      var parsedResult =
          data != null ? MainServicesResponseModel.fromMap(data) : null;
      final decodedResponse =
          ApigeeResponseModel<MainServicesResponseModel>.fromMap(response.data,
              parsedResult: parsedResult);
      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      
      

      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode);
    }
  }*/
}
