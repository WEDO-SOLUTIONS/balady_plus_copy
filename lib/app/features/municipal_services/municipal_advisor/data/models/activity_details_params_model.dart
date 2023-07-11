import 'package:equatable/equatable.dart';

class ActivityDetailsParamsModel extends Equatable {
  final int id;

  const ActivityDetailsParamsModel({
    required this.id,
  });

  @override
  List<Object?> get props => [
        id,
      ];
}
