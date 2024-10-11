import 'dart:convert';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/qa/data/qa_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/errors/errors_exports.dart'
    show NoDataFoundFailure, ServerFailure;
import '../../../../core/services/services_exports.dart'
    show NavigationService, NoParams;
import '../../../../core/utils/enums/bloc_status.dart';
import '../../datasource/remote_data_source.dart';

part 'qa_event.dart';
part 'qa_state.dart';

class QABloc extends Bloc<QADataEvent, QAState> {

  String? serviceId;
  QABloc(this.serviceId) : super(const QAState()) {
    on<GetQADataEvent>(_getQaDataHandler);
    on<GetQADatSearchedaEvent>(_getQaDataSearchedHandler);


    add(const GetQADataEvent());

  }

  Future<void> _getQaDataHandler(GetQADataEvent e, Emitter emitter) async {
    if(serviceId == null)
      return;

    try {

      //
      // if(serviceId == "11429")
      //   {
      //     String qa = "";
      //     if (CommonFunctions.isAppAR) {
      //       qa = await rootBundle.loadString("assets/qa.json");
      //     } else {
      //       qa = await rootBundle.loadString("assets/qa_en.json");
      //     }
      //     var r = json.decode(qa);
      //
      //       List<QAModel>? d = r != null
      //           ? List<QAModel>.from(r.map((x) => QAModel.fromJson(x)))
      //           : null;
      //     emitter(state.copyWith(list: d, filtered: d));
      //   }
      // else {
        QuestionRemoteDataSourceImplementation obj = sl();
        List<QAModel>? d = (await obj.getQuestionList(serviceId!))?.cast<
            QAModel>();
        emitter(state.copyWith(list: d, filtered: d));
     // }


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

  Future<void> _getQaDataSearchedHandler(
      GetQADatSearchedaEvent e, Emitter emitter) async {
    try {
      emitter(state.copyWith(status: BlocStatus.loading));

      List<QAModel>? d = (state.list ?? [])
              .where((element) =>
                  (element.title ?? "").contains(e.text ?? "") ||
                  (element.fieldFaqAnswer ?? "").contains(e.text ?? ""))
              .toList() ??
          [];

      emitter(state.copyWith(filtered: d, status: BlocStatus.success));
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
