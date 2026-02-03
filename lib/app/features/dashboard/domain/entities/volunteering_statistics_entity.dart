import 'package:equatable/equatable.dart';

class VolunteeringStatisticsEntity extends Equatable {
  final String volunteeringHours;
  final String volunteersInProgress;
  final String completedVolunteers;

  const VolunteeringStatisticsEntity({
    required this.volunteeringHours,
    required this.volunteersInProgress,
    required this.completedVolunteers,
  });

  @override
  List<Object?> get props => [volunteeringHours, volunteersInProgress, completedVolunteers];
}
