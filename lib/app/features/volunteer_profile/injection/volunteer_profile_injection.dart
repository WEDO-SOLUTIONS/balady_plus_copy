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
import 'package:balady_plus/app/features/volunteer_profile/domain/use_cases/get_volunteering_services.dart';
import 'package:balady_plus/app/features/volunteer_profile/domain/use_cases/submit_profile.dart';
import 'package:balady_plus/app/features/volunteer_profile/domain/use_cases/upload_cv.dart';

final slVolunteer = GetIt.instance;
class VolunteerProfileInjection {
  static void initialize() {

    // Register BLoC
    slVolunteer.registerLazySingleton<VolunteerProfileBloc>(
      () => VolunteerProfileBloc(
        getProfile: slVolunteer<GetProfile>(),
        getRegions: slVolunteer<GetRegions>(),
        getCities: slVolunteer<GetCities>(),
        getQualifications: slVolunteer<GetQualifications>(),
        getSpecializations: slVolunteer<GetSpecializations>(),
        getLaunguages: slVolunteer<GetLaunguages>(),
        getSkills: slVolunteer<GetSkills>(),
        getLvls: slVolunteer<GetLvls>(),
        getInterests: slVolunteer<GetInterests>(),
        getVolunteeringFields: slVolunteer<GetVolunteeringFields>(),
        getVolunteeringServices: slVolunteer<GetVolunteeringServices>(),
        getBloodTypes: slVolunteer<GetBloodTypes>(),
        getDiseases: slVolunteer<GetDiseases>(),
        uploadCV: slVolunteer<UploadCV>(),
        submitProfile: slVolunteer<SubmitProfile>(),
      ),
    );

    // Register Use Cases
    slVolunteer.registerLazySingleton<GetProfile>(
      () => GetProfile(repository: slVolunteer<VolunteerProfileRepository>()),
    );

    slVolunteer.registerLazySingleton<GetRegions>(
      () => GetRegions(repository: slVolunteer<VolunteerProfileRepository>()),
    );

    slVolunteer.registerLazySingleton<GetCities>(
      () => GetCities(repository: slVolunteer<VolunteerProfileRepository>()),
    );

    slVolunteer.registerLazySingleton<GetQualifications>(
      () => GetQualifications(repository: slVolunteer<VolunteerProfileRepository>()),
    );

    slVolunteer.registerLazySingleton<GetSpecializations>(
      () => GetSpecializations(repository: slVolunteer<VolunteerProfileRepository>()),
    );

    slVolunteer.registerLazySingleton<GetLaunguages>(
      () => GetLaunguages(repository: slVolunteer<VolunteerProfileRepository>()),
    );

    slVolunteer.registerLazySingleton<GetSkills>(
      () => GetSkills(repository: slVolunteer<VolunteerProfileRepository>()),
    );

    slVolunteer.registerLazySingleton<GetLvls>(
      () => GetLvls(repository: slVolunteer<VolunteerProfileRepository>()),
    );

    slVolunteer.registerLazySingleton<GetInterests>(
      () => GetInterests(repository: slVolunteer<VolunteerProfileRepository>()),
    );

    slVolunteer.registerLazySingleton<GetVolunteeringFields>(
      () => GetVolunteeringFields(
          repository: slVolunteer<VolunteerProfileRepository>()),
    );

    slVolunteer.registerLazySingleton<GetVolunteeringServices>(
      () => GetVolunteeringServices(
          repository: slVolunteer<VolunteerProfileRepository>()),
    );

    slVolunteer.registerLazySingleton<GetBloodTypes>(
      () => GetBloodTypes(repository: slVolunteer<VolunteerProfileRepository>()),
    );

    slVolunteer.registerLazySingleton<GetDiseases>(
      () => GetDiseases(repository: slVolunteer<VolunteerProfileRepository>()),
    );

    slVolunteer.registerLazySingleton<UploadCV>(
      () => UploadCV(repository: slVolunteer<VolunteerProfileRepository>()),
    );

    slVolunteer.registerLazySingleton<SubmitProfile>(
      () => SubmitProfile(repository: slVolunteer<VolunteerProfileRepository>()),
    );

    // Register Repository
    slVolunteer.registerLazySingleton<VolunteerProfileRepository>(
      () => VolunteerProfileRepositoryImpl(
        remoteDataSource: slVolunteer<VolunteerProfileRemoteDataSource>(),
      ),
    );

    // Register Data Source
    slVolunteer.registerLazySingleton<VolunteerProfileRemoteDataSource>(
      () => VolunteerDataSourceImpl(webService: slVolunteer<WebService>()),
    );
  }
}
