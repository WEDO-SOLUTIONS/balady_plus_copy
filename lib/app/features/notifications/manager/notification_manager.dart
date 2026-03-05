import 'package:balady_plus/app/core/utils/common_functions.dart';

import '../../../core/dependency_injection/injection_container.dart';
import '../data/data_source/notifications_remote_data_source.dart';
import '../data/model/notification_request.dart';
import '../data/repositories/notification_repository_implementation.dart';

class NotificationManager {
  NotificationRepositoryImplementation repository;
  int counter = 0;
  NotificationManager({
    required this.repository,
  });

  Future<void> updateNotificationSettings(NotificationRequest request) async {
    final failureOrSuccess = await repository.updateNotificationSettings(request);
    failureOrSuccess.fold(
      (failure) {
        if (counter < 2) {
          counter++;
          updateNotificationSettings(request);
        } else {
          counter = 0;
        }
      },
      (result) {
        counter = 0;
      },
    );
  }
}
