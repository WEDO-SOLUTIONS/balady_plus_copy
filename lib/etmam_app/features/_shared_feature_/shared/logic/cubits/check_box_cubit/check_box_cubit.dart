import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;

class CheckBoxCubit extends Cubit<bool> {
  final bool initialState;
  CheckBoxCubit({required this.initialState}) : super(initialState);

  void onChangeState() => emit(!state);
}
