import 'package:equatable/equatable.dart';

class SaveActivitiesParamsModel extends Equatable {
  final String consultationKey;
  final List<int> activitiesIds;

  const SaveActivitiesParamsModel({
    required this.consultationKey,
    required this.activitiesIds,
  });

  @override
  List<Object?> get props => [consultationKey, activitiesIds];
}
