import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;
import 'package:flutter_uxcam/flutter_uxcam.dart';

import '../../../../core/utils/utils_exports.dart' show BottomNavBar;

class BottomNavBarCubit extends Cubit<BottomNavBar> {
  BottomNavBarCubit({required BottomNavBar initialNavBar})
      : super(initialNavBar);

  void onChangeBottomNavBar(int index) {
    emit(BottomNavBar.values.elementAt(index));
    BottomNavBar bar = BottomNavBar.values.elementAt(index);

    if (bar == BottomNavBar.home) {
      FlutterUxcam.tagScreenName("HomePage");
    }

    if (bar == BottomNavBar.services) {
      FlutterUxcam.tagScreenName("ServicesPage");
    }

    if (bar == BottomNavBar.profile) {
      FlutterUxcam.tagScreenName("MorePage");
    }
  }
}
