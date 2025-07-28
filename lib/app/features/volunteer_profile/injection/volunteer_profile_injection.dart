import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/features/volunteer_profile/presentation/bloc/volunteer_profile_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:balady_plus/app/features/volunteer_profile/data/datasource/volunteer_profile_data_source.dart';
import 'package:balady_plus/app/features/volunteer_profile/data/repository/volunteer_profile_repository_impl.dart';
import 'package:balady_plus/app/features/volunteer_profile/domain/repository/volunteer_profile_repository.dart';
import 'package:balady_plus/app/features/volunteer_profile/domain/use_cases/get_blood_types.dart';
import 'package:balady_plus/app/features/volunteer_profile/domain/use_cases/get_cities.dart';
import 'package:balady_plus/app/features/volunteer_profile/domain/use_cases/get_diseases.dart';
import 'package:balady_plus/app/features/volunteer_profile/domain/use_cases/get_interests.dart';
import 'package:balady_plus/app/features/volunteer_profile/domain/use_cases/get_launguages.dart';
import 'package:balady_plus/app/features/volunteer_profile/domain/use_cases/get_lvls.dart';
import 'package:balady_plus/app/features/volunteer_profile/domain/use_cases/get_profile.dart';
import 'package:balady_plus/app/features/volunteer_profile/domain/use_cases/get_qualifications.dart';
import 'package:balady_plus/app/features/volunteer_profile/domain/use_cases/get_regions.dart';
import 'package:balady_plus/app/features/volunteer_profile/domain/use_cases/get_skills.dart';
import 'package:balady_plus/app/features/volunteer_profile/domain/use_cases/get_specializations.dart';
import 'package:balady_plus/app/features/volunteer_profile/domain/use_cases/get_volunteering_fields.dart';
import 'package:balady_plus/app/features/volunteer_profile/domain/use_cases/submit_profile.dart';
import 'package:balady_plus/app/features/volunteer_profile/domain/use_cases/upload_cv.dart';


class VolunteerProfileInjection {
  static void init() {
    final getIt = GetIt.instance;

    // Register BLoC
    getIt.registerFactory<VolunteerProfileBloc>(
      () => VolunteerProfileBloc(
        getProfile: getIt<GetProfile>(),
        getRegions: getIt<GetRegions>(),
        getCities: getIt<GetCities>(),
        getQualifications: getIt<GetQualifications>(),
        getSpecializations: getIt<GetSpecializations>(),
        getLaunguages: getIt<GetLaunguages>(),
        getSkills: getIt<GetSkills>(),
        getLvls: getIt<GetLvls>(),
        getInterests: getIt<GetInterests>(),
        getVolunteeringFields: getIt<GetVolunteeringFields>(),
        getBloodTypes: getIt<GetBloodTypes>(),
        getDiseases: getIt<GetDiseases>(),
        uploadCV: getIt<UploadCV>(),
        submitProfile: getIt<SubmitProfile>(),
      ),
    );

    // Register Use Cases
    getIt.registerLazySingleton<GetProfile>(
      () => GetProfile(repository: getIt<VolunteerProfileRepository>()),
    );

    getIt.registerLazySingleton<GetRegions>(
      () => GetRegions(repository: getIt<VolunteerProfileRepository>()),
    );

    getIt.registerLazySingleton<GetCities>(
      () => GetCities(repository: getIt<VolunteerProfileRepository>()),
    );

    getIt.registerLazySingleton<GetQualifications>(
      () => GetQualifications(repository: getIt<VolunteerProfileRepository>()),
    );

    getIt.registerLazySingleton<GetSpecializations>(
      () => GetSpecializations(repository: getIt<VolunteerProfileRepository>()),
    );

    getIt.registerLazySingleton<GetLaunguages>(
      () => GetLaunguages(repository: getIt<VolunteerProfileRepository>()),
    );

    getIt.registerLazySingleton<GetSkills>(
      () => GetSkills(repository: getIt<VolunteerProfileRepository>()),
    );

    getIt.registerLazySingleton<GetLvls>(
      () => GetLvls(repository: getIt<VolunteerProfileRepository>()),
    );

    getIt.registerLazySingleton<GetInterests>(
      () => GetInterests(repository: getIt<VolunteerProfileRepository>()),
    );

    getIt.registerLazySingleton<GetVolunteeringFields>(
      () => GetVolunteeringFields(
          repository: getIt<VolunteerProfileRepository>()),
    );

    getIt.registerLazySingleton<GetBloodTypes>(
      () => GetBloodTypes(repository: getIt<VolunteerProfileRepository>()),
    );

    getIt.registerLazySingleton<GetDiseases>(
      () => GetDiseases(repository: getIt<VolunteerProfileRepository>()),
    );

    getIt.registerLazySingleton<UploadCV>(
      () => UploadCV(repository: getIt<VolunteerProfileRepository>()),
    );

    getIt.registerLazySingleton<SubmitProfile>(
      () => SubmitProfile(repository: getIt<VolunteerProfileRepository>()),
    );

    // Register Repository
    getIt.registerLazySingleton<VolunteerProfileRepository>(
      () => VolunteerProfileRepositoryImpl(
        remoteDataSource: getIt<VolunteerProfileRemoteDataSource>(),
      ),
    );

    // Register Data Source
    getIt.registerLazySingleton<VolunteerProfileRemoteDataSource>(
      () => VolunteerDataSourceImpl(webService: getIt<WebService>()),
    );
  }
}
