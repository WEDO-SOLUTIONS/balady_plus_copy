import 'dart:convert';

import 'package:balady_plus/app/features/qa/data/qa_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/errors/errors_exports.dart'
    show NoDataFoundFailure, ServerFailure;
import '../../../../core/services/services_exports.dart'
    show NavigationService, NoParams;

part 'qa_event.dart';
part 'qa_state.dart';

class QABloc extends Bloc<QADataEvent, QAState> {
  QABloc() : super(const QAState()) {
    on<GetQADataEvent>(_getQaDataHandler);
    add(const GetQADataEvent());
  }

  Future<void> _getQaDataHandler(GetQADataEvent e, Emitter emitter) async {
    String qa = await rootBundle.loadString("assets/qa.json");
    //print(qa);
    var r = json.decode(qa);
    print(r);
    try {
      List<QAModel>? d = r != null
          ? List<QAModel>.from(r.map((x) => QAModel.fromJson(x)))
          : null;

      emitter(state.copyWith(list: d));

      print(d);
    } catch (ex) {
      print(ex);
    }
    // print(newQAList);
  }
}
