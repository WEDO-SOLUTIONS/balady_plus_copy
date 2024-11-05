import 'package:balady_plus/app/features/ekram/domain/use_cases/delete_attachment.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_cemetery_types_lookup.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_cemetries.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_trip_stations.dart';

import '../../../features/ekram/domain/use_cases/add_trip.dart';
import '../../../features/ekram/domain/use_cases/book_cemetry.dart';
import '../../../features/ekram/domain/use_cases/check_user_info.dart';
import '../../../features/ekram/domain/use_cases/complete_trip.dart';
import '../../../features/ekram/domain/use_cases/delete_trip.dart';
import '../../../features/ekram/domain/use_cases/edit_aditional_data.dart';
import '../../../features/ekram/domain/use_cases/edit_trip.dart';
import '../../../features/ekram/domain/use_cases/get_active_cities.dart';
import '../../../features/ekram/domain/use_cases/get_cemetries_lookup.dart';
import '../../../features/ekram/domain/use_cases/get_cemetry_request_details.dart';
import '../../../features/ekram/domain/use_cases/get_cemetry_requests.dart';
import '../../../features/ekram/domain/use_cases/get_deceased_attachment.dart';
import '../../../features/ekram/domain/use_cases/get_ghusl_employees.dart';
import '../../../features/ekram/domain/use_cases/get_identical_list_request.dart';
import '../../../features/ekram/domain/use_cases/get_deceased_transport_request_details.dart';
import '../../../features/ekram/domain/use_cases/get_ekram_lookups.dart';
import '../../../features/ekram/domain/use_cases/get_launduries_lookup.dart';
import '../../../features/ekram/domain/use_cases/get_locations.dart';
import '../../../features/ekram/domain/use_cases/get_request_details.dart';
import '../../../features/ekram/domain/use_cases/get_mosques_lookup.dart';
import '../../../features/ekram/domain/use_cases/get_status.dart';
import '../../../features/ekram/domain/use_cases/get_trips.dart';
import '../../../features/ekram/domain/use_cases/get_trips_location.dart';
import '../../../features/ekram/domain/use_cases/update_driver_location.dart';
import '../../../features/ekram/domain/use_cases/upload_attachment.dart';
import '../../../features/ekram/ekram_exports.dart';
import '../../../features/ekram/presentation/blocs/driver_extra_data_bloc/extra_data_bloc.dart';
import '../../../features/ekram/presentation/blocs/driver_identical_bloc/identical_list_bloc.dart';
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
    sl.registerLazySingleton(() => GetCemeteryTypesLookUp(repository: sl()));
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
    sl.registerLazySingleton(() => GetIdenticalListRequest(repository: sl()));
    sl.registerLazySingleton(() => GetTrips(repository: sl()));
    sl.registerLazySingleton(() => EditTrip(repository: sl()));
    sl.registerLazySingleton(() => AddTrip(repository: sl()));
    sl.registerLazySingleton(() => GetGhuslEmployees(repository: sl()));
    sl.registerLazySingleton(() => DeleteAttachment(repository: sl()));
    sl.registerLazySingleton(() => GetDeceasedAttachment(repository: sl()));
    sl.registerLazySingleton(() => GetMosquesLookup(repository: sl()));
    sl.registerLazySingleton(() => GetLaundriesLookup(repository: sl()));
    sl.registerLazySingleton(() => DeleteTrip(repository: sl()));
    sl.registerLazySingleton(() => CompleteTrip(repository: sl()));
    sl.registerLazySingleton(() => UploadAttachment(repository: sl()));
    sl.registerLazySingleton(() => UpadateDriverLocation(repository: sl()));
    sl.registerLazySingleton(() => GetTripsLocation(repository: sl()));
    sl.registerLazySingleton(() => GetTripStations(repository: sl()));
    sl.registerLazySingleton(() => EditAdditionalData(repository: sl()));
    sl.registerLazySingleton(() => GetEkramLookUp(repository: sl()));
    sl.registerLazySingleton(() => CheckUserinfo(repository: sl()));
    sl.registerLazySingleton(() => GetCemetries(repository: sl()));
    sl.registerLazySingleton(() => GetActiveCities(repository: sl()));
    sl.registerLazySingleton(() => BookCemetry(repository: sl()));

    sl.registerLazySingleton(() => GetCemetryRequests(repository: sl()));


    sl.registerLazySingleton(() => GetRequestDetails(repository: sl()));

    sl.registerLazySingleton(() => GetCemetryRequestDetails(repository: sl()));

    sl.registerLazySingleton(() => IdenticalListBloc(
        getIdenticalListRequestDetails: sl(), isDriver: true));

    sl.registerLazySingleton(() => ExtraDataBloc(
        getGhuslEmployees: sl(),
        getDeceasedAttachment: sl(),
        uploadAttachment: sl(),
        editAdditionalData: sl(),
        deleteAttachment: sl()));

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
