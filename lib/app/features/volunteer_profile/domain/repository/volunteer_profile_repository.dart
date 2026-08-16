import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:dartz/dartz.dart';

import '../../data/model/cv_upload_response.dart';
import '../../data/model/profile_model/profile_model.dart';
import '../../data/model/volunteer_lookup.dart';


abstract class VolunteerProfileRepository {
  Future<Either<Failure, ProfileModel>> getProfile();
  Future<Either<Failure, List<VolunteerLookup>>> getCities(String regionId);
  Future<Either<Failure, List<VolunteerLookup>>> getRegions();
  Future<Either<Failure, List<VolunteerLookup>>> getSpecializations();
  Future<Either<Failure, List<VolunteerLookup>>> getQualifications();
  Future<Either<Failure, List<VolunteerLookup>>> getLaunguages();
  Future<Either<Failure, List<VolunteerLookup>>> getFields();
  Future<Either<Failure, List<VolunteerLookup>>> getBloodTypes();
  Future<Either<Failure, List<VolunteerLookup>>> getDiseases();
  Future<Either<Failure, List<VolunteerLookup>>> getSkills();
  Future<Either<Failure, List<VolunteerLookup>>> getLvls();
  Future<Either<Failure, List<VolunteerLookup>>> getInterests();
  Future<Either<Failure, List<VolunteerLookup>>> getVolunteeringFields();
  Future<Either<Failure, List<VolunteerLookup>>> getVolunteeringServices(String parentId);
  Future<Either<Failure, CVUploadResponse>> uploadCV(FileDataItem file);
  Future<Either<Failure, void>> submitProfile(
      Map<String, dynamic> profileData, String profileId);
}
