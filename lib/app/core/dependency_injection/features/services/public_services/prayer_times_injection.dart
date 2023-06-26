import '../../../../../features/public_services_features/prayer_times/prayer_times_exports.dart'
    show
        GetPrayerTimes,
        PrayerTimesCubit,
        PrayerTimesRemoteDataSource,
        PrayerTimesRemoteDataSourceImplementation,
        PrayerTimesRepository,
        PrayerTimesRepositoryImplementation;
import '../../../dependency_injection_exports.dart' show sl;

class PrayerTimesInjection {
  static void init() {
    //! Use Case
    sl.registerLazySingleton(() => GetPrayerTimes(sl()));

    //! Repository
    sl.registerLazySingleton<PrayerTimesRepository>(
      () => PrayerTimesRepositoryImplementation(
        remoteDataSource: sl(),
      ),
    );

    //! Data Sources
    sl.registerLazySingleton<PrayerTimesRemoteDataSource>(
      () => PrayerTimesRemoteDataSourceImplementation(
        webService: sl(),
      ),
    );

    //! Bloc
    sl.registerFactory(
      () => PrayerTimesCubit(
        getPrayerTimes: sl(),
      ),
    );
  }
}
