import 'package:equatable/equatable.dart';

class CommercialOfficeEntity extends Equatable {
  final String officeName;
  final String? cityName;
  final String? officeMobile;

  const CommercialOfficeEntity({
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
