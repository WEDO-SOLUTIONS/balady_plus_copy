import 'package:equatable/equatable.dart';

import '../../data/models/entity_violation_activity_model.dart';

class ViolationDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetViolationDetailsEvent extends ViolationDetailsEvent {
  final int noOfOccurences;
  GetViolationDetailsEvent({required this.noOfOccurences});
}
