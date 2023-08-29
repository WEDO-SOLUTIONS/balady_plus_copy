import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_event.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComplianceBloc extends Bloc<ComplianceEvent, ComplianceState> {
  ComplianceBloc()
      : super(const ComplianceState(
          status: BlocStatus.initial,
          currentStep: 0,
          radioSelect: 1,
        )) {
    on<ComplianceEvent>((event, emit) {
      emit(state);
    });
    add(const ComplianceEvent());
    on<ChangePageEvent>(_pageChangeHandler);
    on<RadioSelectEvent>(_radioChangeHandler);
  }
  Future<void> _pageChangeHandler(ChangePageEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      currentStep: e.index,
    ));
  }

  Future<void> _radioChangeHandler(RadioSelectEvent e, Emitter emitter) async {
    emitter(state.copyWith(radioSelect: e.index));
  }
}
