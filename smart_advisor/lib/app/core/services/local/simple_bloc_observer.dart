import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/utils_exports.dart' show Log, StringConversion;

class SimpleBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    "onCreate => bloc/cubit ${bloc.runtimeType} created".hardcoded.successLog();
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    "onChange => $change".hardcoded.actionLog();
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    "onEvent => $event".hardcoded.actionLog();
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    "onTransition => $transition".hardcoded.actionLog();
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    "onError => $error".hardcoded.errorLog();
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    "onClose => bloc/cubit closed ${bloc.runtimeType}".hardcoded.closeLog();
  }
}
