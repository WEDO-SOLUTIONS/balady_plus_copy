import 'package:equatable/equatable.dart';

class ComplianceEvent extends Equatable {
  const ComplianceEvent();

  @override
  List<Object> get props => [];
}

class ChangePageEvent extends ComplianceEvent {
  final double index;
  const ChangePageEvent(this.index);
}

class RadioSelectEvent extends ComplianceEvent {
  final int index;
  const RadioSelectEvent(this.index);
}
