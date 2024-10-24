import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/remote_services/pega_web_service.dart';
import 'package:balady_plus/app/features/events/data/datasource/events_data_source.dart';
import 'package:balady_plus/app/features/events/data/repository/event_repo_impl.dart';
import 'package:balady_plus/app/features/events/domain/repository/events_repository.dart';
import 'package:balady_plus/app/features/events/domain/usecase/get_search_events.dart';

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
