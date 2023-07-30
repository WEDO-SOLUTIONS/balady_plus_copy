import '../dependency_injection_exports.dart' show sl;
import '../../../features/search/search_exports.dart'
    show
        GetSearchData,
        SearchRemoteDataSource,
        SearchLocalDataSource,
        SearchRemoteDataSourceImpl,
        SearchLocalDataSourceImpl,
        SearchRepository,
        SearchRepositoryImpl;

class SearchInjection {
  static void init() {
    //! Use Case
    sl.registerLazySingleton(() => GetSearchData(repository: sl()));

    //! Entities

    //! Repository
    sl.registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
    );

    //! Data Sources
    sl.registerLazySingleton<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(webService: sl()),
    );
    sl.registerLazySingleton<SearchLocalDataSource>(
      () => SearchLocalDataSourceImpl(),
    );
  }
}
