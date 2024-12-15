import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/domain/entities/record_info_entity.dart';

import 'isics_main_activity.dart';

class AddIsicActivityData {
  final List<IsicsMainActivity>? crActivities;
  final String? crNumber;
  final int? requestId;

  AddIsicActivityData({
    this.crActivities,
    this.crNumber,
    this.requestId,

  });

  Map<String, dynamic> toJson() => {
        "crActivities": crActivities == null
            ? []
            : crActivities!.map((x) => x.toJson()).toList(),
        "crNumber": crNumber,
      };
}
