import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/bloc/self_rating_event.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/bloc/self_rating_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelfRatingBloc extends Bloc<SelfRatingEvent, SelfRatingState> {
  SelfRatingBloc()
      : super(const SelfRatingState(
          currentStep: 0,
          status: BlocStatus.initial,
          radioSelect: 1,
        )) {
    on<SelfRatingEvent>(
      (event, emit) {
        emit(state);
      },
    );
    add(const SelfRatingEvent());
    on<SelfRatingChangePageEvent>(_pageChangeHandler);
    on<SelfRatingRadioSelectEvent>(_radioChangeHandler);
  }
  Future<void> _pageChangeHandler(
      SelfRatingChangePageEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      currentStep: e.index,
    ));
  }

  Future<void> _radioChangeHandler(
      SelfRatingRadioSelectEvent e, Emitter emitter) async {
    emitter(state.copyWith(radioSelect: e.index));
  }
}
