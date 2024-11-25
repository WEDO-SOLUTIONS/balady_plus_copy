import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class WorkTimesEntity extends Equatable {
  final String weekDay;
  final List<PeriodEntity> periods;
  final bool isSelected;

  const WorkTimesEntity({
    required this.weekDay,
    this.periods = const [],
    this.isSelected = false,
  });

  @override
  List<Object> get props => [
        weekDay,
        periods,
        isSelected,
      ];

  WorkTimesEntity copyWith({
    String? weekDay,
    List<PeriodEntity>? periods,
    bool? isSelected,
  }) {
    return WorkTimesEntity(
      weekDay: weekDay ?? this.weekDay,
      periods: periods ?? this.periods,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class PeriodEntity extends Equatable {
  final TimeOfDay from;
  final TimeOfDay to;

  const PeriodEntity({
    required this.from,
    required this.to,
  });

  @override
  List<Object> get props => [
        from,
        to,
      ];

  PeriodEntity copyWith({
    TimeOfDay? from,
    TimeOfDay? to,
  }) {
    return PeriodEntity(
      from: from ?? this.from,
      to: to ?? this.to,
    );
  }
}
