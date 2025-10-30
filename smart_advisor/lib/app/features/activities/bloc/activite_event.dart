import 'package:equatable/equatable.dart';

class ActiviteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetActiviteList extends ActiviteEvent {
  final String id;
  GetActiviteList({required this.id});
}
