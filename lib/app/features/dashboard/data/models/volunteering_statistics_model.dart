
import 'package:balady_plus/app/features/dashboard/domain/entities/volunteering_statistics_entity.dart';

class VolunteeringStatisticsModel extends VolunteeringStatisticsEntity {
  const VolunteeringStatisticsModel({
    required super.volunteeringHours,
    required super.volunteersInProgress,
    required super.completedVolunteers,
  });

  factory VolunteeringStatisticsModel.fromJson(Map<String, dynamic> json) {
    return VolunteeringStatisticsModel(
      volunteeringHours: json['volunteering_hours'][0] ?? '-',
      volunteersInProgress: json['volunteers_in_progress'][0] ?? '-',
      completedVolunteers: json['completed_volunteers'][0] ?? '-',
    );
  }
}
