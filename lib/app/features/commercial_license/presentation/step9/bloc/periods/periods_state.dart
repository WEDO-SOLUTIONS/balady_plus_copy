part of 'periods_cubit.dart';

class PeriodsState extends Equatable {
  final List<PeriodEntity> periods;

  const PeriodsState({
    required this.periods,
  });

  bool get is24Hour => periods.isEmpty;

  @override
  List<Object> get props => [periods];

  PeriodsState copyWith({
    List<PeriodEntity>? periods,
  }) {
    return PeriodsState(
      periods: periods ?? this.periods,
    );
  }
}
