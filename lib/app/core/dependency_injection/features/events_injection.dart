import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/features/events/data/datasource/events_data_source.dart';
import 'package:balady_plus/app/features/events/data/repository/event_repo_impl.dart';
import 'package:balady_plus/app/features/events/domain/repository/events_repository.dart';

class EventsInjection {
  static void init() {
    sl.registerLazySingleton<EventRepository>(
      () => EventRepositoryImpl(
        remoteDataSource: sl(),
      ),
    );

    sl.registerLazySingleton<EventsRemoteDataSource>(
      () => EventDataSourceImpl(
        webService: sl(),
      ),
    );
  }
}
