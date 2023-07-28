import 'package:equatable/equatable.dart';

class AdditionalActivitiesParamsModel extends Equatable {
  final String consultationKey;
  final List<int> ids;

  const AdditionalActivitiesParamsModel({
    required this.consultationKey,
    required this.ids,
  });

  @override
  List<Object?> get props => [consultationKey, ids];
}
