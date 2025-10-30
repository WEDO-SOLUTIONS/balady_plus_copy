import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;

import '../../bottom_navigation_pick_item_service.dart';

class BottomNavBarCubit extends Cubit<int> {
  BottomNavBarCubit({required int initialNavBar}) : super(initialNavBar) {
    bottomNavigationPickItemService.onPickItemCallBack = onChangeBottomNavBar;
  }
  void onChangeBottomNavBar(int index) {
    emit(index);
  }
/*  BottomNavBarCubit({required BottomNavBar initialNavBar})
      : super(initialNavBar);*/

  // void onChangeBottomNavBar(int index) =>
  //     emit(BottomNavBar.values.elementAt(index));
}
