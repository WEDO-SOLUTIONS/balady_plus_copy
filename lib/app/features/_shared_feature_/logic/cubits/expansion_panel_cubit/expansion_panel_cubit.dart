import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;

class ExpansionPanelCubit extends Cubit<bool> {
  final bool initialState;
  ExpansionPanelCubit({required this.initialState}) : super(initialState);

  void onChangeState(bool currentState) => emit(currentState);
}

class ExpansionPanelListCubit extends Cubit<int> {
  final int initialIndex;
  ExpansionPanelListCubit({required this.initialIndex}) : super(initialIndex);

  void onChangeState(int panelIndex) => emit(panelIndex);
}
