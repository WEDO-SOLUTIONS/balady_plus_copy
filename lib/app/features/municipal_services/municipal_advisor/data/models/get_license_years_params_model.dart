import 'package:equatable/equatable.dart';

class GetLicenseYearsParamsModel extends Equatable {
  final String activityId;

  const GetLicenseYearsParamsModel({
    required this.activityId,
  });

  Map<String, dynamic> toMap() {
    return {
      'activityId': activityId,
    };
  }

  @override
  List<Object?> get props => [activityId];
}
