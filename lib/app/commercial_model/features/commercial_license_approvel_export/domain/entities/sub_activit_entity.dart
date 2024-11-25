import '../../../../../features/_shared_feature_/shared_feature_exports.dart';

class SubActivityEntity extends DropDownItem {
  final int? id;
  final String? activityName;
  final int? facilityId;
  final String? facilityName;

  const SubActivityEntity({
    this.id,
    this.activityName,
    this.facilityId,
    this.facilityName,
  }) : super(
          name: activityName ?? '',
          id: id ?? '',
        );
}
