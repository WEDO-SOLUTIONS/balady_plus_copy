import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

// Events
abstract class TimePickerEvent {}

class TogglePickerEvent extends TimePickerEvent {
  final int index;

  TogglePickerEvent(this.index);
}

class UpdateTimeEvent extends TimePickerEvent {
  final int index;
  final TimeOfDay timeOfDay;

  UpdateTimeEvent(this.index, this.timeOfDay);
}

// States
class TimePickerState {
  final List<TimeOfDay> selectedTimes;
  final BlocStatus status;

  TimePickerState({
    required this.selectedTimes,
    this.status = BlocStatus.initial,
  });
  TimePickerState copyWith(
      {final List<TimeOfDay>? selectedTimes, final BlocStatus? status}) {
    return TimePickerState(
      selectedTimes: selectedTimes ?? this.selectedTimes,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        selectedTimes,
        status,
      ];
}

// BLoC
class TimePickerBloc extends Bloc<TimePickerEvent, TimePickerState> {
  List<TimeOfDay> _selectedTimes;

  TimePickerBloc()
      : _selectedTimes = List.generate(3, (index) => TimeOfDay.now()),
        super(TimePickerState(
          selectedTimes: List.generate(3, (index) => TimeOfDay.now()),
          status: BlocStatus.initial,
        )) {
    on<TimePickerEvent>(
      (event, emit) {
        if (event is TogglePickerEvent) {
          _selectedTimes[event.index] = _selectedTimes[event.index] == null
              ? TimeOfDay.now()
              : TimeOfDay(hour: 0, minute: 0);
        } else if (event is UpdateTimeEvent) {
          _selectedTimes[event.index] = event.timeOfDay;
        }
        emit(state.copyWith(selectedTimes: _selectedTimes.toList()));
      },
    );
  }
}
