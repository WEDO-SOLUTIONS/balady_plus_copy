import 'package:equatable/equatable.dart';

class TripLocationsResponse extends Equatable {
  final List<TripLocationItem>? items;

  const TripLocationsResponse({this.items});

  @override
  List<Object?> get props => [];
}

class TripLocationItem extends Equatable {
  final String? lastX;
  final String? lastY;

  const TripLocationItem({this.lastX, this.lastY});

  @override
  List<Object?> get props => [lastX, lastY];
}
