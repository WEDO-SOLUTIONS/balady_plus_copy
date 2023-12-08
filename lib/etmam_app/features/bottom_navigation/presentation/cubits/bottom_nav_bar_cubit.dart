import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;
import '../../../../core/utils/utils_exports.dart' show BottomNavBar;

class BottomNavBarCubit extends Cubit<BottomNavBar> {
  BottomNavBarCubit({required BottomNavBar initialNavBar})
      : super(initialNavBar);

  void onChangeBottomNavBar(int index) {
    emit(BottomNavBar.values.elementAt(index));
  }
}
