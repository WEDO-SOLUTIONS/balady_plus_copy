import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/enums/bloc_status.dart';
import '../../data/qa_model.dart';

part 'qa_event.dart';
part 'qa_state.dart';

class QABloc extends Bloc<QADataEvent, QAState> {
  QABloc() : super(const QAState()) {
    on<GetQADataEvent>(_getQaDataHandler);
    on<GetQADatSearchedaEvent>(_getQaDataSearchedHandler);

    add(const GetQADataEvent());
  }

  Future<void> _getQaDataHandler(GetQADataEvent e, Emitter emitter) async {
    String qa = "";
    // if (CommonFunctions.isAppAR) {
    qa = await rootBundle.loadString(
        "packages/smart_advisor/smart_advisor_assets/files/qa/qa.json");
    // } else {
    //   qa = await rootBundle.loadString("assets/qa_en.json");
    // }
    var r = json.decode(qa);
    try {
      List<QAModel>? d = r != null
          ? List<QAModel>.from(r.map((x) => QAModel.fromJson(x)))
          : null;

      emitter(state.copyWith(list: d, filtered: d));
    } catch (error, stackTrace) {
      /* LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );*/
    }
  }

  Future<void> _getQaDataSearchedHandler(
      GetQADatSearchedaEvent e, Emitter emitter) async {
    try {
      emitter(state.copyWith(status: BlocStatus.loading));

      List<QAModel>? d = (state.list ?? [])
              .where((element) =>
                  (element.question ?? "").contains(e.text ?? "") ||
                  (element.answer ?? "").contains(e.text ?? ""))
              .toList() ??
          [];

      emitter(state.copyWith(filtered: d, status: BlocStatus.success));
    } catch (error, stackTrace) {
      /* LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );*/
    }
  }
}
