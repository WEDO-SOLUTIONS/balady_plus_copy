
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
