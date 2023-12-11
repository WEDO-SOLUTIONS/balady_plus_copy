import '../../../features/ekram/domain/use_cases/add_trip.dart';
import '../../../features/ekram/domain/use_cases/book_cemetry.dart';
import '../../../features/ekram/domain/use_cases/check_user_info.dart';
import '../../../features/ekram/domain/use_cases/complete_trip.dart';
import '../../../features/ekram/domain/use_cases/delete_trip.dart';
import '../../../features/ekram/domain/use_cases/download_attachment.dart';
import '../../../features/ekram/domain/use_cases/get_active_cities.dart';
import '../../../features/ekram/domain/use_cases/get_cemetries.dart';
import '../../../features/ekram/domain/use_cases/get_cemetry_request_details.dart';
import '../../../features/ekram/domain/use_cases/get_cemetry_requests.dart';
import '../../../features/ekram/domain/use_cases/get_deceased_driver_request_details.dart';
import '../../../features/ekram/domain/use_cases/get_deceased_transport_request_details.dart';
import '../../../features/ekram/domain/use_cases/get_ekram_lookups.dart';
import '../../../features/ekram/domain/use_cases/get_launduries.dart';
import '../../../features/ekram/domain/use_cases/get_locations.dart';
import '../../../features/ekram/domain/use_cases/get_mosques.dart';
import '../../../features/ekram/domain/use_cases/get_status.dart';
import '../../../features/ekram/domain/use_cases/get_trips.dart';
import '../../../features/ekram/domain/use_cases/get_trips_location.dart';
import '../../../features/ekram/domain/use_cases/update_driver_location.dart';
import '../../../features/ekram/domain/use_cases/upload_trip.dart';
import '../../../features/ekram/ekram_exports.dart';
import '../../../features/ekram_inquiry_service/data/data_sources/remote_data_source.dart';
import '../../../features/ekram_inquiry_service/data/repositories/ekram_repo_impl.dart';
import '../../../features/ekram_inquiry_service/domain/repositories/ekram_repository.dart';
import '../../services/local/location_service.dart';
import '../dependency_injection_exports.dart' show sl;

class EkramInjection {
  static void init() {
    // sl.registerLazySingleton(
    //    () => EkramRequestsBloc(getDeceasedTransportRequests: sl()));

    sl.registerLazySingleton(() => EkramLocationService());
    //! Use Case
    sl.registerLazySingleton(() => GetCities(repository: sl()));
    sl.registerLazySingleton(() => GetNationalities(repository: sl()));
    sl.registerLazySingleton(() => GetHospitals(repository: sl()));
    sl.registerLazySingleton(() => ApplyDeceasedTransport(repository: sl()));
    sl.registerLazySingleton(() => GetLookUp(repository: sl()));
    sl.registerLazySingleton(() => GetStatus(repository: sl()));
    sl.registerLazySingleton(() => GetLocations(repository: sl()));

    sl.registerLazySingleton(
        () => GetDeceasedTransportRequests(repository: sl()));

    sl.registerLazySingleton(
        () => GetDeceasedTransportRequestDetails(repository: sl()));
    sl.registerLazySingleton(
        () => GetDeceasedDriverRequestDetails(repository: sl()));
    sl.registerLazySingleton(() => GetTrips(repository: sl()));
    sl.registerLazySingleton(() => AddTrip(repository: sl()));
    sl.registerLazySingleton(() => GetMosques(repository: sl()));
    sl.registerLazySingleton(() => GetLaundries(repository: sl()));
    sl.registerLazySingleton(() => DeleteTrip(repository: sl()));
    sl.registerLazySingleton(() => CompleteTrip(repository: sl()));
    sl.registerLazySingleton(() => UploadLetter(repository: sl()));
    sl.registerLazySingleton(() => UpadateDriverLocation(repository: sl()));
    sl.registerLazySingleton(() => GetTripsLocation(repository: sl()));
    sl.registerLazySingleton(() => DownloadAttachment(repository: sl()));
    sl.registerLazySingleton(() => GetEkramLookUp(repository: sl()));
    sl.registerLazySingleton(() => CheckUserinfo(repository: sl()));
    sl.registerLazySingleton(() => GetCemetries(repository: sl()));
    sl.registerLazySingleton(() => GetActiveCities(repository: sl()));
    sl.registerLazySingleton(() => BookCemetry(repository: sl()));

    sl.registerLazySingleton(() => GetCemetryRequests(repository: sl()));

    sl.registerLazySingleton(() => GetCemetryRequestDetails(repository: sl()));

    //! Entities

    //! Repository
    sl.registerLazySingleton<EkramRepository>(
      () => EkramRepositoryImpl(remoteDataSource: sl()),
    );
    sl.registerLazySingleton<EkramServicesRepository>(
      () => EkramServicesRepositoryImpl(remoteDataSource: sl()),
    );

    //! Data Sources

    sl.registerLazySingleton<EkramRemoteDataSource>(
      () => EkramRemoteDataSourceImpl(webService: sl()),
    );

    sl.registerLazySingleton<EkramServicesRemoteDataSource>(
      () => EkramServicesRemoteDataSourceImpl(webService: sl()),
    );
  }
}
