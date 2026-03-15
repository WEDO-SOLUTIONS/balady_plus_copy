import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;

import '../../../../core/utils/utils_exports.dart' show BottomNavBar;

typedef BottomNavBarState = ({BottomNavBar? previous, BottomNavBar current});

class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit({required BottomNavBar initialNavBar})
      : previousIndex = initialNavBar.index,
        super((current: initialNavBar, previous: null));

  int? previousIndex;

  void onChangeBottomNavBar(int index) {
    emit((
      previous: previousIndex != null
          ? BottomNavBar.values.elementAt(previousIndex!)
          : null,
      current: BottomNavBar.values.elementAt(index)
    ));
    previousIndex = index;
  }
}
