import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_event.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViolationBloc extends Bloc<ViolationEvent, ViolationState> {
  ViolationBloc()
      : super((const ViolationState(
          selectedIndex: -1,
          status: BlocStatus.initial,
        ))) {
    on<ViolationEvent>((event, emit) {
      emit(state);
    });
    add(const ViolationEvent());
    on<CategorySelectedEvent>(_categoryHandler);
  }
  Future<void> _categoryHandler(
      CategorySelectedEvent e, Emitter emitter) async {
    int selectedIndex = e.index;
    emitter(state.copyWith(
      selectedIndex: selectedIndex,
    ));
  }
}
