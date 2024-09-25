import 'package:balady_plus/app/commercial_model/features/commercial_license/domain/entities/record_info_entity.dart';

class AddIsicActivitiesParams {
  final List<IsicActivity>? crActivities;
  final String? crNumber;
  final String? identityNumber;
  final String? mobileNumber;

  AddIsicActivitiesParams({
    this.crActivities,
    this.crNumber,
    this.identityNumber,
    this.mobileNumber,
  });

  Map<String, dynamic> toJson() => {
        "crActivities": crActivities == null
            ? []
            : crActivities!.map((x) => x.toJson()).toList(),
        "crNumber": crNumber,
        "identityNumber": identityNumber,
        "mobileNumber": mobileNumber,
      };
}
