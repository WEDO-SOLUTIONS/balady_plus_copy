import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

part 'notifications_item_state.dart';

class NotificationsCountCubit extends Cubit<SucceedCountState> {
  final WebService webService;

  NotificationsCountCubit({
    required this.webService,
  }) : super(const SucceedCountState(count: null)) {
    getUnreadMessages();
  }

  Future<void> getUnreadMessages() async {
    var response;
    try {
      // dataHeaders['x-correlation-id'] = CommonFunctions.generateGUID();
      response = await webService.dio.get(
        ApiUrl.notificationsUnreadMessages,
        queryParameters: {
          "status-id": "sent",
        },
        options: Options(
          headers: {
            "x-actor-type-id": "user",
            "x-actor-context-id": "beneficiaries",
            "x-platform-id": "super-app",
            "x-channel-id": "mobile",
            "notification-channel-id": "mobile",
          },
        ),
      );
      final data = response.data;
      final int result = ResponseBodyModel.fromMap(data).data?.result;
      emit(SucceedCountState(count: result));
    } on DioException catch (error) {
      // "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: ex.toString(),
          ),
          response: response,
        );
      }
    }
  }
}
