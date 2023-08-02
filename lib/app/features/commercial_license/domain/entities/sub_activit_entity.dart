import '../../../_shared_feature_/shared_feature_exports.dart';

class SubActivityEntity extends DropDownItem {
  final String activityName;
  final int activityId;
  final int entityType;

  const SubActivityEntity({
    required this.activityName,
    required this.activityId,
    required this.entityType,
  }) : super(name: activityName ?? '', id: activityId ?? '');
}
