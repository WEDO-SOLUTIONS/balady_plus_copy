import 'package:equatable/equatable.dart';

class AdditionalActivitiesParamsModel extends Equatable {
  final String consultationKey;
  final List<(int, double?)> ids;
  final bool? hasSalamaPermit;

  const AdditionalActivitiesParamsModel(
      {required this.consultationKey, required this.ids, this.hasSalamaPermit});

  @override
  List<Object?> get props => [consultationKey, ids, hasSalamaPermit];
}
