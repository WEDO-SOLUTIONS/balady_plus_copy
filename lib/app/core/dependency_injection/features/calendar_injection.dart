import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';

import '../../../features/calendar/data/datasource/calendar_data_source.dart';
import '../../../features/calendar/data/repository/calendar_repo_impl.dart';
import '../../../features/calendar/domain/repository/events_repository.dart';

class CalendarInjection {
  static void init() {
    sl.registerLazySingleton<CalendarRepository>(
      () => CalendarRepositoryImpl(
        remoteDataSource: sl(),
      ),
    );

    sl.registerLazySingleton<CalendarRemoteDataSource>(
      () => CalendarRemoteDataSourceImpl(
        webService: sl(),
      ),
    );
  }
}
