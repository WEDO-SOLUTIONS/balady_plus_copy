part of 'calculator_bloc.dart';

abstract class CalculatorEvent extends Equatable {
  const CalculatorEvent();

  @override
  List<Object?> get props => [];
}

class ChangeAddetionalActivityEvent extends CalculatorEvent {
  final String area;
  final int index;
  const ChangeAddetionalActivityEvent(
      {required this.area, required this.index});
}

class ChangeCleanOptionEvent extends CalculatorEvent {
  final LookUpItem item;
  const ChangeCleanOptionEvent({required this.item});
}

class AddBoardnEvent extends CalculatorEvent {
  final LookUpItem item;
  final String area;
  const AddBoardnEvent({required this.item, required this.area});
}

class ChangeLicenseYears extends CalculatorEvent {
  final LookUpItem item;
  const ChangeLicenseYears({required this.item});
}

class CalculateEvent extends CalculatorEvent {}

class DeleteAddetionalActivityItemEvent extends CalculatorEvent {
  final int index;

  const DeleteAddetionalActivityItemEvent({required this.index});
}

class DeletePermitItemEvent extends CalculatorEvent {
  final int index;

  const DeletePermitItemEvent({required this.index});
}

class DeleteBoardItemEvent extends CalculatorEvent {
  final int index;

  const DeleteBoardItemEvent({required this.index});
}

class ChangePermitWidthEvent extends CalculatorEvent {
  final String data;
  final int index;
  const ChangePermitWidthEvent({required this.data, required this.index});
}

class ChangePermitHeightEvent extends CalculatorEvent {
  final String data;
  final int index;
  const ChangePermitHeightEvent({required this.data, required this.index});
}

class ChangePermitDaysEvent extends CalculatorEvent {
  final String data;
  final int index;
  const ChangePermitDaysEvent({required this.data, required this.index});
}

class ChangePermitNoOfVeichlesEvent extends CalculatorEvent {
  final String data;
  final int index;
  const ChangePermitNoOfVeichlesEvent(
      {required this.data, required this.index});
}

class ChangeAreaValueEvent extends CalculatorEvent {
  final String data;
  const ChangeAreaValueEvent({required this.data});
}

class ChangeUnitCountEvent extends CalculatorEvent {
  final String data;
  const ChangeUnitCountEvent({required this.data});
}

class ChangeAccomodationTypeEvent extends CalculatorEvent {
  final LookUpItem item;
  const ChangeAccomodationTypeEvent({required this.item});
}
