import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/mark_read_notifications_params.dart';
import 'package:balady_plus/app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notifications_item_state.dart';

class NotificationsItemCubit extends Cubit<SucceedCountState> {
  final WebService webService;

  NotificationsItemCubit({
    required this.webService,
  }) : super(const SucceedCountState(count: null));

  Future<void> getUnreadMessages() async {
    var response = await webService.dio.get(
      ApiUrl.notificationsUnreadMessages,
      queryParameters: {"status-id": 2},
    );

    emit(SucceedCountState(count: count));
  }
}
