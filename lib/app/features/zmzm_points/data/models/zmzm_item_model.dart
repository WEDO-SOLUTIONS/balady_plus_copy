import 'package:equatable/equatable.dart';

class ZMZMItemModel extends Equatable {
  final int id;
  final String name;
  final String city;
  final String mapUrl;

  const ZMZMItemModel(
      {required this.id,
      required this.city,
      required this.mapUrl,
      required this.name});

  @override
  List<Object?> get props => [id, name, city, mapUrl];
}
