import 'package:equatable/equatable.dart';

import '../../../vd/domain/entities/gis/gis_params.dart';
import '../../data/models/regulation_clause_response.dart';

class ViolationEvent extends Equatable {
  const ViolationEvent();

  @override
  List<Object> get props => [];
}

class CategorySelectedEvent extends ViolationEvent {
  final int index;
  const CategorySelectedEvent(this.index);
}

class ChangePageEvent extends ViolationEvent {
  final int index;
  const ChangePageEvent(this.index);
}

class GetEstablishmentSizeEvent extends ViolationEvent {
  const GetEstablishmentSizeEvent();
}

class GetViolatorsEvents extends ViolationEvent {
  const GetViolatorsEvents();
}

class GetViolationGuideClassificationsEvents extends ViolationEvent {
  final GISParams? location;

  const GetViolationGuideClassificationsEvents({this.location});
}

class GetRegulationClausess extends ViolationEvent {
  const GetRegulationClausess();
}

class GetRegulationClausesDetails extends ViolationEvent {
  final RegulationClauseItem item;
  final bool refresh;
  final int? index;
  const GetRegulationClausesDetails(
      {required this.item, this.refresh = false, this.index});
}
