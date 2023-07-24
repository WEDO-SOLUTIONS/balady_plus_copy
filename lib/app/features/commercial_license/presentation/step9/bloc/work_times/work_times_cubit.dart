import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../commercial_license_exports.dart';

part 'work_times_state.dart';

class WorkTimesCubit extends Cubit<WorkTimesState> {
  WorkTimesCubit() : super(const WorkTimesState());

  void onSelectedWorkTime(int index) {
    final workTimes = List.of(state.workTimes);
    workTimes[index] = state.workTimes[index].copyWith(
        isSelected: !state.workTimes[index].isSelected, periods: const []);
    emit(state.copyWith(workTimes: workTimes));
  }

  void onAddPeriods({required int index, required List<PeriodEntity> periods}) {
    final workTimes = List.of(state.workTimes);
    workTimes[index] = state.workTimes[index].copyWith(periods: periods);
    emit(state.copyWith(workTimes: workTimes));
  }
}
