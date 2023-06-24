import '../../../../features/profile_features/invoices/invoices_exports.dart'
    show
        GetInvoiceDetails,
        GetInvoiceStatuses,
        GetInvoiceSubTypes,
        GetInvoiceTypes,
        GetInvoices,
        InvoiceDetailsCubit,
        InvoicesBloc,
        InvoicesRemoteDataSource,
        InvoicesRemoteDataSourceImplementation,
        InvoicesRepository,
        InvoicesRepositoryImplementation;
import '../../dependency_injection_exports.dart' show sl;

class InvoicesInjection {
  static void init() {
    //! Use Case
    sl.registerLazySingleton(() => GetInvoices(repository: sl()));
    sl.registerLazySingleton(() => GetInvoiceStatuses(repository: sl()));
    sl.registerLazySingleton(() => GetInvoiceTypes(repository: sl()));
    sl.registerLazySingleton(() => GetInvoiceSubTypes(repository: sl()));
    sl.registerLazySingleton(() => GetInvoiceDetails(repository: sl()));

    //! Repository
    sl.registerLazySingleton<InvoicesRepository>(
      () => InvoicesRepositoryImplementation(
        remoteDataSource: sl(),
      ),
    );

    //! Data Sources
    sl.registerLazySingleton<InvoicesRemoteDataSource>(
      () => InvoicesRemoteDataSourceImplementation(
        webService: sl(),
      ),
    );

    //! Bloc
    sl.registerFactory(
      () => InvoicesBloc(
        getInvoices: sl(),
        getInvoiceStatuses: sl(),
        getMunicipalities: sl(),
        getSubMunicipalities: sl(),
        getInvoiceTypes: sl(),
        getInvoiceSubTypes: sl(),
      ),
    );
    sl.registerFactory(
      () => InvoiceDetailsCubit(sl()),
    );
  }
}
