import 'package:equatable/equatable.dart';

class ServiceCardEntity extends Equatable {
  final String title;
  final String iconName;
  final String description;
  final num rate;
  final int duration;

  const ServiceCardEntity({
    required this.title,
    required this.iconName,
    required this.description,
    required this.rate,
    required this.duration,
  });

  @override
  List<Object?> get props => [
        title,
        iconName,
        description,
        rate,
        duration,
      ];
}
