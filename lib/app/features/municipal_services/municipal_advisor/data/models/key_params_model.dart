import 'package:equatable/equatable.dart';

class KeyParamsModel extends Equatable {
  final String key;
  final int? activityId;
  final double? area;

  const KeyParamsModel({required this.key, this.activityId, this.area});

  @override
  List<Object?> get props => [key, area, activityId];
}
