import '../../../core/dependency_injection/injection_container.dart';
import '../Data/data_source/remote_data_source.dart';
import '../Data/model/notification_request.dart';
import '../Data/repositories/notification_repository_implementation.dart';

class NotificationManager{


  NotificationRepositoryImplementation repository;
  int counter =0;
   NotificationManager({
     required this.repository,
});


  Future<void> updateNotificationSettings(NotificationRequest request ) async {

    final failureOrSuccess = await repository.updateNotificationSettings(request);
    failureOrSuccess.fold(
          (failure) {
          if(counter <3)
            {
              updateNotificationSettings(request);

            }
          else
            {
              counter = 0;
            }

      },
          (result) {
            counter = 0;
      },
    );
  }






  }