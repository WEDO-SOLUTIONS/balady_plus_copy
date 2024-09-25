import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/core/utils/enums/enums.dart';
import '../../../../commercial_license_exports.dart';

part 'periods_state.dart';

class PeriodsCubit extends Cubit<PeriodsState> {
  final List<PeriodEntity> periods;

  PeriodsCubit({required this.periods}) : super(PeriodsState(periods: periods));

  void onChangedPeriodType({required QRWorkTimes type}) =>
      type == QRWorkTimes.OPEN_24HOUR
          ? emit(state.copyWith(periods: const [], type: type))
          : emit(state.copyWith(type: type, periods: [
              const PeriodEntity(
                  from: TimeOfDay(hour: 9, minute: 0),
                  to: TimeOfDay(hour: 17, minute: 0))
            ]));

  void onRemovePeriod(int index) =>
      emit(state.copyWith(periods: List.from(state.periods)..removeAt(index)));

  void onAddPeriod() => emit(state.copyWith(
      periods: List.from(state.periods)
        ..add(const PeriodEntity(
            from: TimeOfDay(hour: 9, minute: 0),
            to: TimeOfDay(hour: 17, minute: 0)))));

  void onTimeFromChanged({required int index, required TimeOfDay time}) {
    final periods = List.of(state.periods);
    periods[index] = state.periods[index].copyWith(from: time);
    emit(state.copyWith(periods: periods));
  }

  void onTimeToChanged({required int index, required TimeOfDay time}) {
    final periods = List.of(state.periods);
    periods[index] = state.periods[index].copyWith(to: time);
    emit(state.copyWith(periods: periods));
  }
}
