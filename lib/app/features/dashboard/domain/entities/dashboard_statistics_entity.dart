import 'package:equatable/equatable.dart';

class DashboardStatisticsEntity extends Equatable {
  final int keyId;
  final String keyName;
  final num count;

  const DashboardStatisticsEntity({
    required this.keyId,
    required this.keyName,
    required this.count,
  });

  @override
  List<Object?> get props => [keyId, keyName, count];
}
