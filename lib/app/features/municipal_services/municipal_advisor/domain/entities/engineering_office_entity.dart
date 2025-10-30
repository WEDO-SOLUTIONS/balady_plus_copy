import 'package:equatable/equatable.dart';

class EngineeringOfficeEntity extends Equatable {
  final String officeName;
  final String? cityName;
  final String? officeMobile;

  const EngineeringOfficeEntity({
    required this.officeName,
    this.cityName,
    this.officeMobile,
  });

  @override
  List<Object?> get props => [
        officeName,
        cityName,
        officeMobile,
      ];
}
