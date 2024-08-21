import 'dart:convert';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/bloc/self_rating_event.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/bloc/self_rating_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/self_rating_item.dart';

class SelfRatingBloc extends Bloc<SelfRatingEvent, SelfRatingState> {
  SelfRatingBloc()
      : super(const SelfRatingState(
          currentStep: 0,
          status: BlocStatus.initial,
        )) {
    on<SelfRatingEvent>(
      (event, emit) {
        emit(state);
      },
    );
    add(const SelfRatingEvent());
    on<SelfRatingChangePageEvent>(_pageChangeHandler);
    on<SelfRatingRadioSelectEvent>(_radioChangeHandler);

    on<InitSelfRatingEvent>(_init);
    add(const InitSelfRatingEvent());
  }
  Future<void> _pageChangeHandler(
      SelfRatingChangePageEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      currentStep: e.index,
    ));
  }

  Future<void> _radioChangeHandler(
      SelfRatingRadioSelectEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    List<SelfRatingItem> list = state.items ?? [];

    list[e.index].compliance = e.compliance;

    emitter(state.copyWith(items: list, status: BlocStatus.success));
  }

  Future<void> _init(InitSelfRatingEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    String qa = await rootBundle.loadString("assets/self_rating.json");
    if (!CommonFunctions.isAppAR)
      qa = await rootBundle.loadString("assets/self_rating_en.json");
    var r = json.decode(qa);

    try {
      List<SelfRatingItem>? d = r != null
          ? List<SelfRatingItem>.from(r.map((x) => SelfRatingItem.fromMap(x)))
          : null;

      emitter(state.copyWith(items: d, status: BlocStatus.success));
    } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
  }
}
