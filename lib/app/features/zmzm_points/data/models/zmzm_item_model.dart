import 'package:equatable/equatable.dart';

class ZMZMItemModel extends Equatable {
  final int id;
  final String name;
  final String city;
  final String mapUrl;
  final double latitude;
  final double longitude;

  const ZMZMItemModel({
    required this.id,
    required this.city,
    required this.mapUrl,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [id, name, city, mapUrl];
}
