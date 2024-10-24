import 'package:equatable/equatable.dart';

import '../../data/models/entity_violation_activity_model.dart';

class DetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetRegulationsEvent extends DetailsEvent {
  GetRegulationsEvent();
}

class GetEntityActivityDetailsEvent extends DetailsEvent {
  GetEntityActivityDetailsEvent();
}

class GetViolationsListEvent extends DetailsEvent {
  GetViolationsListEvent();
}

class GetViolationDetailsEvent extends DetailsEvent {
  EntityViolationActivityModel item;
  GetViolationDetailsEvent({required this.item});
}

class GetViolationVD extends DetailsEvent {
  GetViolationVD();
}
