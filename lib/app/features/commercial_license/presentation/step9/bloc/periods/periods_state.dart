part of 'periods_cubit.dart';

class PeriodsState extends Equatable {
  final List<PeriodEntity> periods;
  final QRWorkTimes? type;
  const PeriodsState({required this.periods, this.type});

  bool get is24Hour => periods.isEmpty;

  @override
  List<Object?> get props => [periods, type];

  PeriodsState copyWith(
      {List<PeriodEntity>? periods, final QRWorkTimes? type}) {
    return PeriodsState(
        periods: periods ?? this.periods, type: type ?? this.type);
  }
}
