import '../../../core/dependency_injection/injection_container.dart';
import '../Data/data_source/remote_data_source.dart';
import '../Data/model/notification_request.dart';
import '../Data/repositories/notification_repository_implementation.dart';

class NotificationManager{


  NotificationRepositoryImplementation repository;
   NotificationManager({
     required this.repository,
});


  Future<void> updateNotificationSettings(NotificationRequest request ) async {

    final failureOrSuccess = await repository.updateNotificationSettings(request);
    failureOrSuccess.fold(
          (failure) {
            print(failure);
      },
          (result) {
        print(result);
      },
    );
  }






  }